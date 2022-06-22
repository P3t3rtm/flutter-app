import 'package:flutter/material.dart';
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
  int cindex = 0;

  @override
  void initState() {
    super.initState();
    GroupProducts();
  }

  void GroupProducts() async {
    final fetchproductsResponse = await fetchproducts();
    if (fetchproductsResponse.statusCode != 200) return;
    List<Product> products = (json.decode(fetchproductsResponse.body) as List)
        .map((data) => Product.fromJson(data))
        .toList();
    //group products by category
    for (var product in products) {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //todo search all async functions and make sure they dont queue spam due to intermitten connection,,,,
          //use variable to prevent spamming: eg. fetchAttempting = true , if code != 200, then set fetchAttempting = false and show error
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: themeColor,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ScrollableListTabView(
        tabHeight: 48,
        bodyAnimationDuration: const Duration(milliseconds: 150),
        tabAnimationCurve: Curves.easeOut,
        tabAnimationDuration: const Duration(milliseconds: 200),
        tabs: [
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
                              width: queryData.size.width * 0.2 - 30,
                              margin: EdgeInsets.only(
                                  left: queryData.size.width * 0.2 - 15,
                                  top: 10,
                                  bottom: 10),
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'Qty',
                                ),
                                keyboardType: TextInputType
                                    .number, //TODO POSITIVE INTEGER ONLY, look up storing listbuilder variable
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ))),
          // ScrollableListTab(
          //     tab: ListTab(
          //         label: Text(cindex > 1 ? groupedLists.keys.elementAt(1) : '',
          //             style: TextStyle(fontWeight: FontWeight.w700))),
          //     body: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: cindex > 1
          //           ? groupedLists[groupedLists.keys.elementAt(1)].length
          //           : 0,
          //       itemBuilder: (_, index) => ListTile(
          //         leading: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle, color: Colors.grey),
          //           alignment: Alignment.center,
          //           child: Text(index.toString()),
          //         ),
          //         title: Text(cindex > 1
          //             ? groupedLists[groupedLists.keys.elementAt(1)][index].name
          //             : ''),
          //       ),
          //     )),
          // ScrollableListTab(
          //     tab: ListTab(
          //         label: Text(cindex > 2 ? groupedLists.keys.elementAt(2) : '',
          //             style: TextStyle(fontWeight: FontWeight.w700))),
          //     body: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: cindex > 2
          //           ? groupedLists[groupedLists.keys.elementAt(2)].length
          //           : 0,
          //       itemBuilder: (_, index) => ListTile(
          //         leading: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle, color: Colors.grey),
          //           alignment: Alignment.center,
          //           child: Text(index.toString()),
          //         ),
          //         title: Text(cindex > 2
          //             ? groupedLists[groupedLists.keys.elementAt(2)][index].name
          //             : ''),
          //       ),
          //     )),
          // ScrollableListTab(
          //     tab: ListTab(
          //         label: Text(cindex > 3 ? groupedLists.keys.elementAt(3) : '',
          //             style: TextStyle(fontWeight: FontWeight.w700))),
          //     body: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: cindex > 3
          //           ? groupedLists[groupedLists.keys.elementAt(3)].length
          //           : 0,
          //       itemBuilder: (_, index) => ListTile(
          //         leading: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle, color: Colors.grey),
          //           alignment: Alignment.center,
          //           child: Text(index.toString()),
          //         ),
          //         title: Text(cindex > 3
          //             ? groupedLists[groupedLists.keys.elementAt(3)][index].name
          //             : ''),
          //       ),
          //     )),
          // ScrollableListTab(
          //     tab: ListTab(
          //         label: Text(cindex > 4 ? groupedLists.keys.elementAt(4) : '',
          //             style: TextStyle(fontWeight: FontWeight.w700))),
          //     body: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: cindex > 4
          //           ? groupedLists[groupedLists.keys.elementAt(4)].length
          //           : 0,
          //       itemBuilder: (_, index) => ListTile(
          //         leading: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle, color: Colors.grey),
          //           alignment: Alignment.center,
          //           child: Text(index.toString()),
          //         ),
          //         title: Text(cindex > 4
          //             ? groupedLists[groupedLists.keys.elementAt(4)][index].name
          //             : ''),
          //       ),
          //     )),
          // ScrollableListTab(
          //     tab: ListTab(
          //         label: Text(cindex > 5 ? groupedLists.keys.elementAt(5) : '',
          //             style: TextStyle(fontWeight: FontWeight.w700))),
          //     body: ListView.builder(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: cindex > 5
          //           ? groupedLists[groupedLists.keys.elementAt(5)].length
          //           : 0,
          //       itemBuilder: (_, index) => ListTile(
          //         leading: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle, color: Colors.grey),
          //           alignment: Alignment.center,
          //           child: Text(index.toString()),
          //         ),
          //         title: Text(cindex > 5
          //             ? groupedLists[groupedLists.keys.elementAt(5)][index].name
          //             : ''),
          //       ),
          //     ))
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
