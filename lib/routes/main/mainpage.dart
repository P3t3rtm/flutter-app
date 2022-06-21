import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/main/drawerleftpage.dart';
import 'package:makemyown/routes/main/drawerrightpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   @override
//   void initState() {
//     //you are not allowed to add async modifier to initState
//     Future.delayed(Duration.zero, () async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       try {
//         final fetchResponse = await fetchData();
//         if (fetchResponse.statusCode == 200) {
//           Map<String, dynamic> result = json.decode(fetchResponse.body);
//         } else if (fetchResponse.statusCode == 403) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Session Expired.')),
//           );
//           userJwtToken = '';
//           await prefs.setString('jwt', '');
//           Navigator.pushReplacementNamed(context, '/auth');
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text(
//                     'Error (EOE): fetching addresses. Please try agian later.')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//                   Text('Error fetching addresses. Please try agian later.')),
//         );
//         userJwtToken = '';
//         await prefs.setString('jwt', '');
//         Navigator.pushReplacementNamed(context, '/auth');
//       }
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: appTheme(),
//       child: WillPopScope(
//         onWillPop: () async => false,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           drawer: const LeftDrawer(),
//           endDrawer: const RightDrawer(),
//           body: CustomScrollView(
//             slivers: <Widget>[
//               SliverAppBar(
//                 //toolbarHeight: 20,
//                 //collapsedHeight: 30,
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 pinned: false,
//                 snap: false,
//                 floating: true,
//                 expandedHeight: 70.0,
//                 leading: Builder(
//                   builder: (context) {
//                     return IconButton(
//                       icon: const Icon(Icons.settings_outlined, size: 30),
//                       onPressed: () {
//                         Scaffold.of(context).openDrawer();
//                       },
//                     );
//                   },
//                 ),
//                 actions: <Widget>[
//                   Builder(
//                     builder: (context) {
//                       return IconButton(
//                         color: mainCartHasItems ? themeColor : Colors.black,
//                         icon: Icon(
//                           mainCartHasItems
//                               ? Icons.shopping_cart
//                               : Icons.shopping_cart_outlined,
//                           size: 30,
//                         ),
//                         onPressed: () {
//                           Scaffold.of(context).openEndDrawer();
//                         },
//                       );
//                     },
//                   )
//                 ],
//                 flexibleSpace: FlexibleSpaceBar(
//                   centerTitle: true,
//                   title: TextButton(
//                     clipBehavior: Clip.hardEdge,
//                     style: ElevatedButton.styleFrom(
//                       splashFactory: InkSplash.splashFactory,
//                       primary: Colors.transparent,
//                     ),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/selectaddress');
//                     },
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.35,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 13,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     'Delivery',
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         fontWeight: FontWeight.w800,
//                                         color: themeColor),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: SizedBox(
//                                     width: 8,
//                                     child: Container(
//                                       margin: const EdgeInsets.only(top: 2),
//                                       child: FittedBox(
//                                         fit: BoxFit.none,
//                                         child: Icon(
//                                           Icons.arrow_drop_down_rounded,
//                                           color: themeColor,
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Container(
//                   margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
//                   child: Text(
//                     'All Restaurants',
//                     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) {
//                     //make the following container a tapable card
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/menu');
//                       },
//                       child: Container(
//                         clipBehavior: Clip.hardEdge,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(5),
//                               topRight: Radius.circular(5),
//                               bottomLeft: Radius.circular(5),
//                               bottomRight: Radius.circular(5)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 1,
//                               blurRadius: 5,
//                               // changes position of shadow (x,y)
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
//                         height: 275,
//                         width: queryData.size.width,
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 200,
//                               child: SizedBox.expand(
//                                 child: FittedBox(
//                                   fit: BoxFit.cover,
//                                   clipBehavior: Clip.hardEdge,
//                                   child: CachedNetworkImage(
//                                     imageUrl: imgUrl + "2.png",
//                                     errorWidget: (context, url, error) =>
//                                         Container(
//                                       padding: EdgeInsets.all(0.5 *
//                                           queryData.size
//                                               .width), //the bigger the number the smaller the loading bar
//                                       child: const Icon(
//                                           Icons.report_problem_outlined),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 75,
//                               child: Column(
//                                 children: [
//                                   const SizedBox(height: 15),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: queryData.size.width * 0.5 - 15,
//                                         padding:
//                                             const EdgeInsets.only(left: 15),
//                                         child: Text(
//                                           'Lee Chee',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15),
//                                         ),
//                                       ),
//                                       //todo implement rating system 4.3 stars icon
//                                       Container(
//                                         width: queryData.size.width * 0.5 - 15,
//                                         padding:
//                                             const EdgeInsets.only(right: 15),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             Text(
//                                               '', //'4.3',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.black54),
//                                             ),
//                                             Container(
//                                               padding: const EdgeInsets.only(
//                                                   left: 3, bottom: 2),
//                                               height: 15,
//                                               child: const FittedBox(
//                                                 fit: BoxFit.none,
//                                                 // child: Icon(
//                                                 //   Icons.star_rate_rounded,
//                                                 //   color: Colors.black54,
//                                                 //   size: 20,
//                                                 // ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: queryData.size.width * 0.5 - 15,
//                                         padding:
//                                             const EdgeInsets.only(left: 15),
//                                         child: Text(
//                                           'Fried Chicken, Fingers, Steak, Chowmein, Burgers',
//                                           style: const TextStyle(
//                                             overflow: TextOverflow.ellipsis,
//                                             color: Colors.black54,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         width: queryData.size.width * 0.5 - 15,
//                                         padding:
//                                             const EdgeInsets.only(right: 15),
//                                         // child: Text(
//                                         //   '+ 1,242 ratings',
//                                         //   textAlign: TextAlign.right,
//                                         //   style: const TextStyle(
//                                         //       color: Colors.black54,
//                                         //       fontWeight: FontWeight.w500),
//                                         // ),
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   childCount: 1,
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Container(
//                   margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
//                   child: Row(
//                     children: const [
//                       Expanded(
//                           child: Divider(
//                         height: 0,
//                         thickness: 1,
//                         endIndent: 15,
//                       )),
//                       Text(
//                         'more coming soon..',
//                         style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54),
//                       ),
//                       Expanded(
//                           child: Divider(
//                         height: 0,
//                         thickness: 1,
//                         indent: 15,
//                       )),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           bottomNavigationBar: SafeArea(
//             bottom: true,
//             child: BottomAppBar(
//               color: Colors.white,
//               child: SizedBox(
//                 height: 55,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.33,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           splashFactory: NoSplash.splashFactory,
//                           primary: Colors.white,
//                           side: const BorderSide(width: 0, color: Colors.white),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             mainPageRestaurant = true;
//                             mainPageOrders = false;
//                             mainPageSearch = false;
//                           });
//                           //change address page
//                         },
//                         child: FittedBox(
//                           fit: BoxFit.fitHeight,
//                           child: Column(
//                             children: <Widget>[
//                               const SizedBox(height: 5),
//                               Icon(Icons.restaurant_menu,
//                                   size: 30,
//                                   color: mainPageRestaurant
//                                       ? themeColor
//                                       : Colors.black54),
//                               Text(
//                                 'Restaurants',
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: mainPageRestaurant
//                                         ? themeColor
//                                         : Colors.black54),
//                               ),
//                               const SizedBox(height: 5),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.33,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           splashFactory: NoSplash.splashFactory,
//                           primary: Colors.white,
//                           side: const BorderSide(width: 0, color: Colors.white),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             mainPageRestaurant = false;
//                             mainPageOrders = false;
//                             mainPageSearch = true;
//                           });
//                           //change address page
//                         },
//                         child: FittedBox(
//                           fit: BoxFit.fitHeight,
//                           child: Column(
//                             children: <Widget>[
//                               const SizedBox(height: 5),
//                               Icon(Icons.search_rounded,
//                                   size: 30,
//                                   color: mainPageSearch
//                                       ? themeColor
//                                       : Colors.black54),
//                               Text(
//                                 'Search',
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: mainPageSearch
//                                         ? themeColor
//                                         : Colors.black54),
//                               ),
//                               const SizedBox(height: 5),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.33,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           splashFactory: NoSplash.splashFactory,
//                           primary: Colors.white,
//                           side: const BorderSide(width: 0, color: Colors.white),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             mainPageRestaurant = false;
//                             mainPageOrders = true;
//                             mainPageSearch = false;
//                           });
//                           //change address page
//                         },
//                         child: FittedBox(
//                           fit: BoxFit.fitHeight,
//                           child: Column(
//                             children: <Widget>[
//                               const SizedBox(height: 5),
//                               Icon(Icons.list_alt_rounded,
//                                   size: 30,
//                                   color: mainPageOrders
//                                       ? themeColor
//                                       : Colors.black54),
//                               Text(
//                                 'Orders',
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: mainPageOrders
//                                         ? themeColor
//                                         : Colors.black54),
//                               ),
//                               const SizedBox(height: 5),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// //fetches necessary data from server if refresh token is expired, stuff like permissions, etc
//   Future<http.Response> fetchData() async {
//     try {
//       return await http.get(
//         Uri.parse('${apiUrl}data/fetch?jwtToken=$userJwtToken'),
//         headers: {"api": rushHourApiKey, "jwt": userJwtToken},
//       ).timeout(const Duration(seconds: 5));
//     } catch (e) {
//       return http.Response('', 500);
//     }
//   }
// }
