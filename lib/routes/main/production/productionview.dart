import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/helpers.dart';
import '../sidemenu/drawerleftpage.dart';
import 'package:http/http.dart' as http;

class ProductionView extends StatefulWidget {
  const ProductionView({Key? key}) : super(key: key);
  @override
  State<ProductionView> createState() => _ProductionViewState();
}

class _ProductionViewState extends State<ProductionView> {
  var userMap = {};
  var lotMap = {};
  var quantityMap = {};
  List<Production> productions = [];
  List<User> users = [];

  //late Timer timer;
  int counter = 0;
  int lastping = 0;

  @override
  void initState() {
    userCurrentPage = 'Production';
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
    final fetchProductionResponse = await fetchproduction();
    final fetchUserResponse = await fetchusers();
    if (fetchProductionResponse.statusCode != 200 ||
        fetchUserResponse.statusCode != 200) return;
    productions = (json.decode(fetchProductionResponse.body) as List)
        .map((data) => Production.fromJson(data))
        .toList();
    users = (json.decode(fetchUserResponse.body) as List)
        .map((data) => User.fromJson(data))
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
    print(lotMap);
    // print(quantityMap);
    // print(userMap);
    print(lotMap.length);
    //print the first entry of lotMap
    print(lotMap.values.first);

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
                    userCurrentPage,
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
                        //Navigator.pushNamed(context, '/productiondetailsview');
                        print(productions[index].isConfirmed);
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
                                    'Quantity: ${quantityMap.values.elementAt(index)}',
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

  Future<http.Response> fetchproduction() async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}production/fetchproduction'),
        headers: {"api": xapikey, "jwt": userJwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }

  Future<http.Response> fetchusers() async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}data/fetchusers'),
        headers: {"api": xapikey, "jwt": userJwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}

class User {
  final String firstName;
  final String lastName;
  final int id;
  final int colorID;

  User(this.firstName, this.lastName, this.id, this.colorID);

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        id = json['id'],
        colorID = json['colorID'];
}

class Production {
  final int id;
  final int lotNumber;
  final int quantity;
  final int productID;
  final int userID;
  final int timestamp;
  final bool isConfirmed;

  Production(this.lotNumber, this.quantity, this.productID, this.userID,
      this.timestamp, this.id, this.isConfirmed);

  Production.fromJson(Map<String, dynamic> json)
      : lotNumber = json['lotNumber'],
        quantity = json['quantity'],
        id = json['id'],
        productID = json['productID'],
        userID = json['userID'],
        timestamp = json['createdAt'],
        isConfirmed = json['isConfirmed'];
}
