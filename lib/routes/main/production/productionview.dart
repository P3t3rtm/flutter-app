import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
  late Timer timer;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => print('timer'));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
            child: const Icon(
              Icons.add,
              size: 35,
            ),
            backgroundColor: themeColor,
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: Container(
                      color: Colors.green,
                      height: 15.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '(OK: 5281 ms)',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )),
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
                  (BuildContext context, int index) {
                    //make the following container a tapable card
                    return GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, '/productiondetailsview');
                        print('pressed $index');
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
                              child: const Icon(
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
                                    'Quantity: $index',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: queryData.size.width * 0.5 - 15,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Peter Tan',
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
                  childCount: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
