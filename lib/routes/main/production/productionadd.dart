// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/helpers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class ProductionAdd extends StatefulWidget {
  const ProductionAdd({Key? key}) : super(key: key);

  @override
  State<ProductionAdd> createState() => _ProductionAddState();
}

class _ProductionAddState extends State<ProductionAdd> {
  var groupedLists = {};
  var textcontrollers = {};
  var nametrackers = {};
  int cindex = 0;

  @override
  void initState() {
    super.initState();
    userCurrentPage = 'Production Add';
    GroupProducts();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //dispose all the text controllers in textcontrollers
    for (var key in textcontrollers.keys) {
      textcontrollers[key].dispose();
    }
    super.dispose();
  }

  void GroupProducts() async {
    final fetchproductsResponse = await fetchproducts();
    if (fetchproductsResponse.statusCode != 200) return;
    List<Product> products = (json.decode(fetchproductsResponse.body) as List)
        .map((data) => Product.fromJson(data))
        .toList();
    //group products by category
    for (var product in products) {
      textcontrollers[product.id] = TextEditingController();
      nametrackers[product.id] = product.name;

      if (groupedLists.containsKey(product.category)) {
        groupedLists[product.category].add(product);
      } else {
        cindex++;
        groupedLists[product.category] = [product];
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This list of controllers can be used to set and get the text from/to the TextFields

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //if not usercurrentpage is productionadd return
          if (userCurrentPage != 'Production Add') return;

          //check if at least one textfield is NOT empty
          bool isEmpty = true;
          for (var key in textcontrollers.keys) {
            if (textcontrollers[key].text.isNotEmpty) {
              isEmpty = false;
              break;
            }
          }

          if (isEmpty) {
            //scaffoldmessenger snackbar to show that at least one textfield must not be empty
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('At least one textfield must not be empty'),
              duration: Duration(seconds: 2),
            ));
          } else {
            //if at least one textfield is not empty, log the action first using http logaction, then post the data to the server

            //loop through the textcontrollers if the text is not empty, send the entire array to the server using http productionadd function together
            //with the text of the textcontroller

            //first, reset the data variable
            data = {};

            for (var key in textcontrollers.keys) {
              // for all product ids in textcontrollers
              if (textcontrollers[key].text.isNotEmpty) {
                //if the quantity text of the productid textcontroller is not empty
                //initiate the "values" key pair map first if it does not exist
                if (data.isEmpty) {
                  data['values'] = [];
                }
                data['values'].add({
                  'productID': key,
                  'quantity': int.parse(textcontrollers[key].text),
                  'name': nametrackers[key],
                  'isChecked': false
                });
              }
            }
            Navigator.pushNamed(context, '/Production Confirm');
          }
          //todo search all async functions and make sure they dont queue spam due to intermitten connection,,,,
          //use variable to prevent spamming: eg. fetchAttempting = true , if code != 200, then set fetchAttempting = false and show error
        },
        backgroundColor: themeColor,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Production Add',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        //leading go back button,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeColor,
          ),
          onPressed: () {
            userCurrentPage = 'Production';
            Navigator.pop(context);
          },
        ),
      ),
      body: ScrollableListTabView(
        tabHeight: 48,
        bodyAnimationDuration: const Duration(milliseconds: 150),
        tabAnimationCurve: Curves.easeOut,
        tabAnimationDuration: const Duration(milliseconds: 200),
        tabs: [
          //6 categories currently change 6 numbers

          ScrollableListTab(
              tab: ListTab(
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 0
                          ? groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 0)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cindex > /*CHANGE THIS=================*/ 0
                      ? groupedLists[groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 0)]
                          .length
                      : 0,
                  itemBuilder: (_, index) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              // changes position of shadow (x,y)
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        height: 70,
                        width: queryData.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: queryData.size.width * 0.5 - 15,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                groupedLists[groupedLists.keys.elementAt(
                                            /*CHANGE THIS=================*/ 0)]
                                        [index]
                                    .name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            //a container with a textfield to add quantity
                            Container(
                              width: queryData.size.width * 0.3 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.1 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                controller: textcontrollers[groupedLists[
                                            groupedLists.keys.elementAt(
                                                /*CHANGE THIS=================*/ 0)]
                                        [index]
                                    .id],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                  counterText: "",

                                  //hide max length indicator
                                  //labeltext centeralign
                                ),
                                keyboardType: TextInputType
                                    // ignore: todo
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable (dynamically generate variables? controller? to track the value)
                                //numbers only
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      ))),
          ScrollableListTab(
              tab: ListTab(
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 1
                          ? groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 1)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cindex > /*CHANGE THIS=================*/ 1
                      ? groupedLists[groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 1)]
                          .length
                      : 0,
                  itemBuilder: (_, index) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              // changes position of shadow (x,y)
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        height: 70,
                        width: queryData.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: queryData.size.width * 0.5 - 15,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                groupedLists[groupedLists.keys.elementAt(
                                            /*CHANGE THIS=================*/ 1)]
                                        [index]
                                    .name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            //a container with a textfield to add quantity
                            Container(
                              width: queryData.size.width * 0.3 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.1 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                controller: textcontrollers[groupedLists[
                                            groupedLists.keys.elementAt(
                                                /*CHANGE THIS=================*/ 1)]
                                        [index]
                                    .id],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                  counterText: "",

                                  //hide max length indicator
                                  //labeltext centeralign
                                ),
                                keyboardType: TextInputType
                                    // ignore: todo
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable (dynamically generate variables? controller? to track the value)
                                //numbers only
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      ))),
          ScrollableListTab(
              tab: ListTab(
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 2
                          ? groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 2)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cindex > /*CHANGE THIS=================*/ 2
                      ? groupedLists[groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 2)]
                          .length
                      : 0,
                  itemBuilder: (_, index) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              // changes position of shadow (x,y)
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        height: 70,
                        width: queryData.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: queryData.size.width * 0.5 - 15,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                groupedLists[groupedLists.keys.elementAt(
                                            /*CHANGE THIS=================*/ 2)]
                                        [index]
                                    .name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            //a container with a textfield to add quantity
                            Container(
                              width: queryData.size.width * 0.3 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.1 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                controller: textcontrollers[groupedLists[
                                            groupedLists.keys.elementAt(
                                                /*CHANGE THIS=================*/ 2)]
                                        [index]
                                    .id],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                  counterText: "",

                                  //hide max length indicator
                                  //labeltext centeralign
                                ),
                                keyboardType: TextInputType
                                    // ignore: todo
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable (dynamically generate variables? controller? to track the value)
                                //numbers only
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      ))),
          ScrollableListTab(
              tab: ListTab(
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 3
                          ? groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 3)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cindex > /*CHANGE THIS=================*/ 3
                      ? groupedLists[groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 3)]
                          .length
                      : 0,
                  itemBuilder: (_, index) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              // changes position of shadow (x,y)
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        height: 70,
                        width: queryData.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: queryData.size.width * 0.5 - 15,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                groupedLists[groupedLists.keys.elementAt(
                                            /*CHANGE THIS=================*/ 3)]
                                        [index]
                                    .name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            //a container with a textfield to add quantity
                            Container(
                              width: queryData.size.width * 0.3 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.1 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                controller: textcontrollers[groupedLists[
                                            groupedLists.keys.elementAt(
                                                /*CHANGE THIS=================*/ 3)]
                                        [index]
                                    .id],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                  counterText: "",

                                  //hide max length indicator
                                  //labeltext centeralign
                                ),
                                keyboardType: TextInputType
                                    // ignore: todo
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable (dynamically generate variables? controller? to track the value)
                                //numbers only
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      ))),
          ScrollableListTab(
              tab: ListTab(
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 4
                          ? groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 4)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cindex > /*CHANGE THIS=================*/ 4
                      ? groupedLists[groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 4)]
                          .length
                      : 0,
                  itemBuilder: (_, index) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              // changes position of shadow (x,y)
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        height: 70,
                        width: queryData.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: queryData.size.width * 0.5 - 15,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                groupedLists[groupedLists.keys.elementAt(
                                            /*CHANGE THIS=================*/ 4)]
                                        [index]
                                    .name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            //a container with a textfield to add quantity
                            Container(
                              width: queryData.size.width * 0.3 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.1 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                controller: textcontrollers[groupedLists[
                                            groupedLists.keys.elementAt(
                                                /*CHANGE THIS=================*/ 4)]
                                        [index]
                                    .id],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                  counterText: "",

                                  //hide max length indicator
                                  //labeltext centeralign
                                ),
                                keyboardType: TextInputType
                                    // ignore: todo
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable (dynamically generate variables? controller? to track the value)
                                //numbers only
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      ))),
          ScrollableListTab(
              tab: ListTab(
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 5
                          ? groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 5)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cindex > /*CHANGE THIS=================*/ 5
                      ? groupedLists[groupedLists.keys
                              .elementAt(/*CHANGE THIS=================*/ 5)]
                          .length
                      : 0,
                  itemBuilder: (_, index) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              // changes position of shadow (x,y)
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        height: 70,
                        width: queryData.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            Container(
                              width: queryData.size.width * 0.5 - 15,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                groupedLists[groupedLists.keys.elementAt(
                                            /*CHANGE THIS=================*/ 5)]
                                        [index]
                                    .name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            //a container with a textfield to add quantity
                            Container(
                              width: queryData.size.width * 0.3 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.1 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                controller: textcontrollers[groupedLists[
                                            groupedLists.keys.elementAt(
                                                /*CHANGE THIS=================*/ 5)]
                                        [index]
                                    .id],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                  counterText: "",

                                  //hide max length indicator
                                  //labeltext centeralign
                                ),
                                keyboardType: TextInputType
                                    // ignore: todo
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable (dynamically generate variables? controller? to track the value)
                                //numbers only
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                                maxLength: 5,
                              ),
                            ),
                          ],
                        ),
                      )))
        ],
      ),
    );
  }

  Future<http.Response> fetchproducts() async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}production/fetchproducts'),
        headers: {"api": xapikey, "jwt": userJwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}

class Product {
  final String name;
  final String category;
  final int id;

  Product(this.name, this.category, this.id);

  Product.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        category = json['category'],
        id = json['id'];

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'category': category,
  //       'id': id,
  //     };
}
