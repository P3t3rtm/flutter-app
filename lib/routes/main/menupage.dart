import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_to_index/scroll_to_index.dart';
import '../helpers.dart';
import 'drawerleftpage.dart';
import 'drawerrightpage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const maxCount = 100;
  final scrollDirection = Axis.vertical;

  late AutoScrollController controller;

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 250.0;

  @override
  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    //you are not allowed to add async modifier to initState
    // Future.delayed(Duration.zero, () async {
    //   try {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     final fetchResponse = await fetchMenu(sinkMenuId);
    //     if (fetchResponse.statusCode == 200) {
    //       Map<String, dynamic> result = json.decode(fetchResponse.body);
    //       userCurrentAddressName = result['currentAddressName'];
    //       userCurrentAddressId = result['currentAddressId'];
    //     } else if (fetchResponse.statusCode == 403) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Session Expired.')),
    //       );
    //       userJwtToken = '';
    //       await prefs.setString('jwt', '');
    //       Navigator.pushReplacementNamed(context, '/auth');
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //             content: Text(
    //                 'Error (EOE): fetching addresses. Please try agian later.')),
    //       );
    //     }
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content:
    //               Text('Error fetching addresses. Please try agian later.')),
    //     );
    //   }
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme(),
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _scrollToIndex,
            tooltip: 'Increment',
            child: Text(counter.toString()),
          ),
          backgroundColor: Colors.white,
          drawer: const LeftDrawer(),
          endDrawer: const RightDrawer(),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: controller,
            slivers: <Widget>[
              SliverAppBar(
                stretch: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 250.0,
                automaticallyImplyLeading: false,
                leading: CircleAvatar(
                  maxRadius: 15,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 30, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                actions: <Widget>[
                  Builder(
                    builder: (context) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          color: mainCartHasItems ? themeColor : Colors.black,
                          icon: Icon(
                            mainCartHasItems
                                ? Icons.shopping_cart
                                : Icons.shopping_cart_outlined,
                            size: 30,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      );
                    },
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  collapseMode: CollapseMode.parallax,
                  centerTitle: false,
                  titlePadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  title: ValueListenableBuilder(
                    valueListenable: _titlePaddingNotifier,
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                // ignore: unnecessary_cast
                                (value as double) > 0 ? (value as double) : 0),
                        child: Text(
                          "Lee Chee",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                  background: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: SizedBox(
                          height: 215,
                          width: queryData.size.width,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: imgUrl + "2.png",
                              errorWidget: (context, url, error) => Container(
                                padding: EdgeInsets.all(0.5 *
                                    queryData.size
                                        .width), //the bigger the number the smaller the loading bar
                                child:
                                    const Icon(Icons.report_problem_outlined),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 15,
                      //   margin: EdgeInsets.only(top: 200),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.only(
                      //       bottomLeft: Radius.circular(15),
                      //       bottomRight: Radius.circular(15),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: const Text(
                    'Menu Bar',
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
                        Navigator.pushNamed(context, '/sample');
                      },
                      child: AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
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
                                      imageUrl: imgUrl + "2.png",
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
                                          width:
                                              queryData.size.width * 0.5 - 15,
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            'Lee Chee $index',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        //todo implement rating system 4.3 stars icon
                                        Container(
                                          width:
                                              queryData.size.width * 0.5 - 15,
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
                                          width:
                                              queryData.size.width * 0.5 - 15,
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
                                          width:
                                              queryData.size.width * 0.5 - 15,
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
                      ),
                    );
                  },
                  childCount: 154,
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
                        'prices are set entirely by the merchant',
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

  int counter = -1;
  Future _scrollToIndex() async {
    setState(() {
      counter++;

      if (counter >= maxCount) counter = 0;
    });

    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }

  Future<http.Response> fetchMenu(menuId) async {
    try {
      return await http.get(
        Uri.parse(apiUrl + 'menu/fetch?menuId=$menuId'),
        headers: {"api": rushHourApiKey, "jwt": userJwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (controller.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * controller.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }
}
