// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/helpers.dart';
import '../sidemenu/drawerleftpage.dart';

class ProductionView extends StatefulWidget {
  const ProductionView({Key? key}) : super(key: key);
  @override
  State<ProductionView> createState() => _ProductionViewState();
}

class _ProductionViewState extends State<ProductionView> {
  //late Timer timer;
  int counter = 0;
  int lastping = 0;

  @override
  void initState() {
    productionMap = {};

    lotMap = [];
    userMap = [];
    productMap = [];

    userData.currentPage = 'Production';
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 10), (Timer t) {});
    fetchdata();
  }

  @override
  void dispose() {
    //timer.cancel();

    super.dispose();
  }

  void fetchdata() async {
    final fetchLotResponse = await fetchlots();
    if (fetchLotResponse.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failure to fetch lots.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    //populate lotMap with lots from fetchLotResponse
    lotMap = json.decode(fetchLotResponse.body);

    //foreach lot in lotMap, fetch its productions
    for (var lot in lotMap) {
      final fetchProductionResponse = await fetchproduction(lot['id']);
      if (fetchProductionResponse.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failure to fetch production.'),
          duration: Duration(seconds: 2),
        ));
        return;
      }
      productionMap[lot['id']] = json.decode(fetchProductionResponse.body);
    }
    //sum up production quantities using lotNumber
    for (var lot in lotMap) {
      num sum = 0;
      for (var production in productionMap[lot['id']]) {
        sum += production['quantity'];
      }
      lot['quantity'] = sum;
    }

    final fetchUserResponse = await httpfetchusers();
    if (fetchUserResponse.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failure to fetch users.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    //populate userMap with users from fetchUserResponse
    userMap = json.decode(fetchUserResponse.body);

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
              Navigator.of(context).pushNamed('/Production Add');
            },
            backgroundColor: themeColor,
            child: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                forceElevated: true,
                // bottom: PreferredSize(
                //     preferredSize: const Size.fromHeight(0.0),
                //     child: Container(
                //       color: Colors.green,
                //       height: 15.0,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           Text(
                //             '(OK: 281 ms)',
                //             style: TextStyle(
                //                 fontSize: 10,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.white),
                //           ),
                //         ],
                //       ),
                //     )),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                pinned: false,
                snap: false,
                floating: true,
                expandedHeight: 70.0,
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
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    userData.currentPage,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  //childCount should be size of lotMap
                  childCount: lotMap.length,
                  (BuildContext context, int index) {
                    //make the following container a tapable card
                    return GestureDetector(
                      onTap: () {
                        userData.currentLot = lotMap[index]['id'];
                        for (var product
                            in productionMap[userData.currentLot]) {
                          product['isChecked'] = false;
                        }
                        Navigator.pushNamed(context, '/Production Details');
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //warning icon
                            Container(
                              margin: const EdgeInsets.only(left: 50),
                              child: lotMap[index]['isConfirmed'] == 1
                                  ? Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: themeColor,
                                      size: 30,
                                    )
                                  : lotMap[index]['isConfirmed'] == 0
                                      ? const Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.orangeAccent,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.remove_circle_outline_rounded,
                                          color: Colors.redAccent,
                                          size: 30,
                                        ),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 15),
                                Container(
                                  width: queryData.size.width * 0.5 - 15,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    //'Lot #${lotMap.keys.elementAt(index)} Qty: ${quantityMap.values.elementAt(index)}',
                                    'Qty: ${lotMap[index]['quantity']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: queryData.size.width * 0.5 - 15,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    //find firstname from list of maps userMap where id matches lotMap[index]['userId']
                                    '${userMap.firstWhere((user) => user['id'] == lotMap[index]['userID'])['firstName']} ${userMap.firstWhere((user) => user['id'] == lotMap[index]['userID'])['lastName']}',

                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
