// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/helpers.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class ProductionAdd extends StatefulWidget {
  const ProductionAdd({Key? key}) : super(key: key);

  @override
  State<ProductionAdd> createState() => _ProductionAddState();
}

class _ProductionAddState extends State<ProductionAdd> {
  //map of list of products
  var displayMap = {};
  int cindex = 0;

  @override
  void initState() {
    super.initState();
    //used to prevent spam due to intermittent connection
    userData.currentPage = 'Production Add';
    setDisplayMap();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //dispose all the text controllers in textcontrollers
    for (var product in productMap) {
      product['textController'].dispose();
    }
    super.dispose();
  }

  void setDisplayMap() async {
    displayMap = {};
    for (var product in productMap) {
      product['textController'] = TextEditingController();

      if (displayMap.containsKey(product['category'])) {
        displayMap[product['category']].add(product);
      } else {
        //used to track the category of the map, used for .elementAt()
        cindex++;
        displayMap[product['category']] = [product];
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This list of controllers can be used to set and get the text from/to the TextFields

    return WillPopScope(
      onWillPop: () async {
        userData.currentPage = 'Production';
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //if not usercurrentpage is productionadd return
            if (userData.currentPage != 'Production Add') return;

            //check if at least one textfield is NOT empty
            bool isEmpty = true;
            for (var product in productMap) {
              if (product['textController'].text.isNotEmpty) {
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
              //if at least one textfield is not empty, post the data to the server

              //loop through the textcontrollers if the text is not empty, send the entire array to the server

              //first, reset the map variable
              productionAddMap = {};

              for (var product in productMap) {
                // for all product ids in textcontrollers
                if (product['textController'].text.isNotEmpty) {
                  //if the quantity text of the productid textcontroller is not empty
                  //initiate the "values" key pair map first if it does not exist
                  if (productionAddMap.isEmpty) {
                    productionAddMap['values'] = [];
                  }
                  productionAddMap['values'].add({
                    'productID': product['id'],
                    'quantity': int.parse(product['textController'].text),
                    'name': product['name'],
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
              size: 30,
            ),
            onPressed: () {
              userData.currentPage = 'Production';
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
                    activeBackgroundColor: themeColor,
                    label: Text(
                        cindex > /*CHANGE THIS=================*/ 0
                            ? displayMap.keys
                                .elementAt(/*CHANGE THIS=================*/ 0)
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cindex > /*CHANGE THIS=================*/ 0
                        ? displayMap.values
                            .elementAt(/*CHANGE THIS=================*/ 0)
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
                                  displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 0)[
                                      index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                  controller: displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 0)[
                                      index]['textController'],

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Qty',
                                    counterText: "",

                                    //hide max length indicator
                                    //labeltext centeralign
                                  ),
                                  keyboardType: TextInputType.number,
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
                    activeBackgroundColor: themeColor,
                    label: Text(
                        cindex > /*CHANGE THIS=================*/ 1
                            ? displayMap.keys
                                .elementAt(/*CHANGE THIS=================*/ 1)
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cindex > /*CHANGE THIS=================*/ 1
                        ? displayMap.values
                            .elementAt(/*CHANGE THIS=================*/ 1)
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
                                  displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 1)[
                                      index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                  controller: displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 1)[
                                      index]['textController'],

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Qty',
                                    counterText: "",

                                    //hide max length indicator
                                    //labeltext centeralign
                                  ),
                                  keyboardType: TextInputType.number,
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
                    activeBackgroundColor: themeColor,
                    label: Text(
                        cindex > /*CHANGE THIS=================*/ 2
                            ? displayMap.keys
                                .elementAt(/*CHANGE THIS=================*/ 2)
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cindex > /*CHANGE THIS=================*/ 2
                        ? displayMap.values
                            .elementAt(/*CHANGE THIS=================*/ 2)
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
                                  displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 2)[
                                      index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                  controller: displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 2)[
                                      index]['textController'],

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Qty',
                                    counterText: "",

                                    //hide max length indicator
                                    //labeltext centeralign
                                  ),
                                  keyboardType: TextInputType.number,
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
                    activeBackgroundColor: themeColor,
                    label: Text(
                        cindex > /*CHANGE THIS=================*/ 3
                            ? displayMap.keys
                                .elementAt(/*CHANGE THIS=================*/ 3)
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cindex > /*CHANGE THIS=================*/ 3
                        ? displayMap.values
                            .elementAt(/*CHANGE THIS=================*/ 3)
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
                                  displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 3)[
                                      index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                  controller: displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 3)[
                                      index]['textController'],

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Qty',
                                    counterText: "",

                                    //hide max length indicator
                                    //labeltext centeralign
                                  ),
                                  keyboardType: TextInputType.number,
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
                    activeBackgroundColor: themeColor,
                    label: Text(
                        cindex > /*CHANGE THIS=================*/ 4
                            ? displayMap.keys
                                .elementAt(/*CHANGE THIS=================*/ 4)
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                body: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cindex > /*CHANGE THIS=================*/ 4
                        ? displayMap.values
                            .elementAt(/*CHANGE THIS=================*/ 4)
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
                                  displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 4)[
                                      index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                  controller: displayMap.values.elementAt(
                                          /*CHANGE THIS=================*/ 4)[
                                      index]['textController'],

                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    labelText: 'Qty',
                                    counterText: "",

                                    //hide max length indicator
                                    //labeltext centeralign
                                  ),
                                  keyboardType: TextInputType.number,
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
                  activeBackgroundColor: themeColor,
                  label: Text(
                      cindex > /*CHANGE THIS=================*/ 5
                          ? displayMap.keys
                              .elementAt(/*CHANGE THIS=================*/ 5)
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              body: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cindex > /*CHANGE THIS=================*/ 5
                    ? displayMap.values
                            .elementAt(/*CHANGE THIS=================*/ 5)
                            .length +
                        1
                    : 0,
                itemBuilder: (_, index) {
                  if (index == displayMap.values.elementAt(5).length) {
                    return SizedBox(
                      height: 150,
                    );
                  }
                  return Container(
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
                            displayMap.values.elementAt(
                                    /*CHANGE THIS=================*/ 5)[index]
                                ['name'],
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
                            controller: displayMap.values.elementAt(
                                    /*CHANGE THIS=================*/ 5)[index]
                                ['textController'],

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
                            keyboardType: TextInputType.number,
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
