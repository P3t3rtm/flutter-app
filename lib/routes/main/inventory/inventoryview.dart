// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/helpers.dart';
import '../sidemenu/drawerleftpage.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({Key? key}) : super(key: key);
  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  var displayMap = {};
  int cindex = 0;

  @override
  void initState() {
    userData.currentPage = 'Inventory';
    super.initState();
    fetchdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchdata() async {
    //fetch products
    final fetchProductResponse = await fetchproducts();
    if (fetchProductResponse.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failure to fetch products.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    //populate products from fetchProductResponse
    productMap = json.decode(fetchProductResponse.body);
    setDisplayMap();
  }

  void setDisplayMap() async {
    displayMap = {};
    for (var product in productMap) {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: const LeftDrawer(),
          //add a floatingactionbutton to push to productionadd page
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Add Product');
            },
            backgroundColor: themeColor,
            child: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              userData.currentPage,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            toolbarHeight: 70,
            //leading go back button,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  color: themeColor,
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          body: RefreshIndicator(
            color: themeColor,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                fetchdata();
              });
            },
            child: ScrollableListTabView(
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
                                ? displayMap.keys.elementAt(
                                    /*CHANGE THIS=================*/ 0)
                                : '',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cindex > /*CHANGE THIS=================*/ 0
                            ? displayMap.values
                                .elementAt(/*CHANGE THIS=================*/ 0)
                                .length
                            : 0,
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () {
                                userData.currentProduct = displayMap.values
                                        .elementAt(
                                            /*CHANGE THIS=================*/ 0)[
                                    index]['id'];
                                Navigator.pushNamed(
                                    context, '/Product Details');
                              },
                              child: Container(
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
                                margin:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                      margin: EdgeInsets.only(
                                          left: queryData.size.width * 0.1,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        displayMap.values
                                            .elementAt(/*CHANGE THIS=================*/ 0)[
                                                index]['quantity']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                ScrollableListTab(
                    tab: ListTab(
                        activeBackgroundColor: themeColor,
                        label: Text(
                            cindex > /*CHANGE THIS=================*/ 1
                                ? displayMap.keys.elementAt(
                                    /*CHANGE THIS=================*/ 1)
                                : '',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cindex > /*CHANGE THIS=================*/ 1
                            ? displayMap.values
                                .elementAt(/*CHANGE THIS=================*/ 1)
                                .length
                            : 0,
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () {
                                userData.currentProduct = displayMap.values
                                        .elementAt(
                                            /*CHANGE THIS=================*/ 1)[
                                    index]['id'];
                                Navigator.pushNamed(
                                    context, '/Product Details');
                              },
                              child: Container(
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
                                margin:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                      margin: EdgeInsets.only(
                                          left: queryData.size.width * 0.1,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        displayMap.values
                                            .elementAt(/*CHANGE THIS=================*/ 1)[
                                                index]['quantity']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                ScrollableListTab(
                    tab: ListTab(
                        activeBackgroundColor: themeColor,
                        label: Text(
                            cindex > /*CHANGE THIS=================*/ 2
                                ? displayMap.keys.elementAt(
                                    /*CHANGE THIS=================*/ 2)
                                : '',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cindex > /*CHANGE THIS=================*/ 2
                            ? displayMap.values
                                .elementAt(/*CHANGE THIS=================*/ 2)
                                .length
                            : 0,
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () {
                                userData.currentProduct = displayMap.values
                                        .elementAt(
                                            /*CHANGE THIS=================*/ 2)[
                                    index]['id'];
                                Navigator.pushNamed(
                                    context, '/Product Details');
                              },
                              child: Container(
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
                                margin:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                      margin: EdgeInsets.only(
                                          left: queryData.size.width * 0.1,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        displayMap.values
                                            .elementAt(/*CHANGE THIS=================*/ 2)[
                                                index]['quantity']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                ScrollableListTab(
                    tab: ListTab(
                        activeBackgroundColor: themeColor,
                        label: Text(
                            cindex > /*CHANGE THIS=================*/ 3
                                ? displayMap.keys.elementAt(
                                    /*CHANGE THIS=================*/ 3)
                                : '',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cindex > /*CHANGE THIS=================*/ 3
                            ? displayMap.values
                                .elementAt(/*CHANGE THIS=================*/ 3)
                                .length
                            : 0,
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () {
                                userData.currentProduct = displayMap.values
                                        .elementAt(
                                            /*CHANGE THIS=================*/ 3)[
                                    index]['id'];
                                Navigator.pushNamed(
                                    context, '/Product Details');
                              },
                              child: Container(
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
                                margin:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                      margin: EdgeInsets.only(
                                          left: queryData.size.width * 0.1,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        displayMap.values
                                            .elementAt(/*CHANGE THIS=================*/ 3)[
                                                index]['quantity']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                ScrollableListTab(
                    tab: ListTab(
                        activeBackgroundColor: themeColor,
                        label: Text(
                            cindex > /*CHANGE THIS=================*/ 4
                                ? displayMap.keys.elementAt(
                                    /*CHANGE THIS=================*/ 4)
                                : '',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cindex > /*CHANGE THIS=================*/ 4
                            ? displayMap.values
                                .elementAt(/*CHANGE THIS=================*/ 4)
                                .length
                            : 0,
                        itemBuilder: (_, index) => GestureDetector(
                              onTap: () {
                                userData.currentProduct = displayMap.values
                                        .elementAt(
                                            /*CHANGE THIS=================*/ 4)[
                                    index]['id'];
                                Navigator.pushNamed(
                                    context, '/Product Details');
                              },
                              child: Container(
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
                                margin:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                      margin: EdgeInsets.only(
                                          left: queryData.size.width * 0.1,
                                          top: 10,
                                          bottom: 10),
                                      child: Text(
                                        displayMap.values
                                            .elementAt(/*CHANGE THIS=================*/ 4)[
                                                index]['quantity']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
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
                        return const SizedBox(
                          height: 150,
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          userData.currentProduct = displayMap.values.elementAt(
                              /*CHANGE THIS=================*/ 5)[index]['id'];
                          Navigator.pushNamed(context, '/Product Details');
                        },
                        child: Container(
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
                                          /*CHANGE THIS=================*/ 5)[
                                      index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              //a container with a textfield to add quantity
                              Container(
                                margin: EdgeInsets.only(
                                    left: queryData.size.width * 0.1,
                                    top: 10,
                                    bottom: 10),
                                child: Text(
                                  displayMap.values
                                      .elementAt(/*CHANGE THIS=================*/ 5)[
                                          index]['quantity']
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
