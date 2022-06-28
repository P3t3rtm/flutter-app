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
    userData.currentPage = 'Production';
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 10), (Timer t) {});
    fetchdata();
  }

  @override
  void dispose() {
    //timer.cancel();
    lotMap.clear();
    userMap.clear();
    quantityMap.clear();
    users.clear();
    products.clear();
    productions.clear();

    super.dispose();
  }

  void fetchdata() async {
    final fetchProductionResponse = await fetchproduction();
    final fetchUserResponse = await httpfetchusers();
    final fetchProductsResponse = await fetchproducts();
    if (fetchProductionResponse.statusCode != 200 ||
        fetchUserResponse.statusCode != 200 ||
        fetchProductsResponse.statusCode != 200) return;
    productions = (json.decode(fetchProductionResponse.body) as List)
        .map((data) => Production.fromJson(data))
        .toList();
    users = (json.decode(fetchUserResponse.body) as List)
        .map((data) => User.fromJson(data))
        .toList();
    products = (json.decode(fetchProductsResponse.body) as List)
        .map((data) => Product.fromJson(data))
        .toList();
    //group users by id

    for (var user in users) {
      userMap[user.id] = [user];
    }

    //group productions by lotNumber using lotMap
    for (var production in productions) {
      if (lotMap[production.lotNumber] == null) {
        lotMap[production.lotNumber] = [production];
      } else {
        lotMap[production.lotNumber].add(production);
      }
      //sum up production quantities using lotNumber
      if (quantityMap[production.lotNumber] == null) {
        quantityMap[production.lotNumber] = production.quantity;
      } else {
        quantityMap[production.lotNumber] += production.quantity;
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
                        productionCurrentLot = lotMap.keys.elementAt(index);
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
                              child:
                                  lotMap.values.elementAt(index)[0].isConfirmed
                                      ? Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: themeColor,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.orangeAccent,
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
                                    'Qty: ${quantityMap.values.elementAt(index)}',
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
                                    //first and last name of user
                                    userMap[lotMap.values
                                                .elementAt(index)[0]
                                                .userID][0]
                                            .firstName +
                                        ' ' +
                                        userMap[lotMap.values
                                                .elementAt(index)[0]
                                                .userID][0]
                                            .lastName,

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
