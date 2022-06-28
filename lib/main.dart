import '/routes/main/production/productionview.dart';

import 'routes/loginsystem/auth_splash.dart';
import 'package:flutter/material.dart';
import 'routes/loginsystem/login_page.dart';
import 'routes/loginsystem/verifyemail.dart';
import 'routes/main/production/productionadd.dart';
import 'routes/main/production/productionconfirm.dart';
import 'routes/main/production/productiondetailsview.dart';

void main() {
  runApp(
    MaterialApp(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.1,
          ), //set desired text scale factor here
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'TTNorms',
          scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),

        '/login': (context) => const AuthPage(),

        '/Production': (context) => const ProductionView(),
        '/Production Add': (context) => const ProductionAdd(),
        '/Production Confirm': (context) => const ProductionConfirm(),
        '/Production Details': (context) => const ProductionDetails(),
        //'/menuitem': (context) => const MenuItemPage(),

        //'/orders': (context) => const OrdersPage(),
        //'/search': (context) => const SearchPage(),

        //'/changepass': (context) => const ChangePasswordPage(),
        //'/forgotpass': (context) => const ForgotPasswordPage(),

        '/verifyemail': (context) => const VerifyEmailPage(),
      },
    ),
  );
}

//#region =========================DELIVERY PAGE================================
//#endregion
//#region =========================PICKUP PAGE==================================
//#endregion
//#region =========================OFFERS PAGE==================================
//#endregion
//#region =========================SEARCH PAGE==================================
//#endregion
//#region =========================ORDERS PAGE==================================
//#endregion
//#region =========================PAYMENT PAGE=================================
//#endregion
//#region =========================SETTINGS PAGE================================
//todo: profile / payment methods / addresses / contact support (get help) / become a partner restaurant / now hiring / frequently asked questions ()/ legal / logout /

//#endregion