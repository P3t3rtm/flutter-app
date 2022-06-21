import 'dart:async';

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
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                //toolbarHeight: 20,
                //collapsedHeight: 30,
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
                  title: TextButton(
                    clipBehavior: Clip.hardEdge,
                    style: ElevatedButton.styleFrom(
                      splashFactory: InkSplash.splashFactory,
                      primary: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/selectaddress');
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 13,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Delivery',
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: themeColor),
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 8,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      child: FittedBox(
                                        fit: BoxFit.none,
                                        child: Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: themeColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Text(
                    'All Restaurants',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    //make the following container a tapable card
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/menu');
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
                        height: 275,
                        width: queryData.size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  clipBehavior: Clip.hardEdge,
                                  child: CachedNetworkImage(
                                    imageUrl: "${imgUrl}2.png",
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      padding: EdgeInsets.all(0.5 *
                                          queryData.size
                                              .width), //the bigger the number the smaller the loading bar
                                      child: const Icon(
                                          Icons.report_problem_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Container(
                                        width: queryData.size.width * 0.5 - 15,
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          'Lee Chee',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      //todo implement rating system 4.3 stars icon
                                      Container(
                                        width: queryData.size.width * 0.5 - 15,
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '', //'4.3',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 3, bottom: 2),
                                              height: 15,
                                              child: const FittedBox(
                                                fit: BoxFit.none,
                                                // child: Icon(
                                                //   Icons.star_rate_rounded,
                                                //   color: Colors.black54,
                                                //   size: 20,
                                                // ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: queryData.size.width * 0.5 - 15,
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          'Fried Chicken, Fingers, Steak, Chowmein, Burgers',
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: queryData.size.width * 0.5 - 15,
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        // child: Text(
                                        //   '+ 1,242 ratings',
                                        //   textAlign: TextAlign.right,
                                        //   style: const TextStyle(
                                        //       color: Colors.black54,
                                        //       fontWeight: FontWeight.w500),
                                        // ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                    children: const [
                      Expanded(
                          child: Divider(
                        height: 0,
                        thickness: 1,
                        endIndent: 15,
                      )),
                      Text(
                        'more coming soon..',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      Expanded(
                          child: Divider(
                        height: 0,
                        thickness: 1,
                        indent: 15,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
