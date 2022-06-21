import 'package:makemyown/routes/main/sample.dart';

import 'routes/main/menupage.dart';
import 'routes/loginsystem/auth_splash.dart';
import 'package:flutter/material.dart';
import 'routes/loginsystem/login_page.dart';
import 'routes/loginsystem/verifyemail.dart';
import 'routes/main/mainpage.dart';

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
        '/auth': (context) => const AuthPage(),

        '/main': (context) => const MainPage(),
        '/menu': (context) => const MenuPage(),

        '/sample': (context) => SamplePage(),
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