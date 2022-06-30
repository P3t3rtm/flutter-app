import '/routes/main/production/productionview.dart';

import 'routes/loginsystem/auth_splash.dart';
import 'package:flutter/material.dart';
import 'routes/loginsystem/login_page.dart';
import 'routes/loginsystem/verifyemail.dart';
import 'routes/main/inventory/inventoryaddproduct.dart';
import 'routes/main/inventory/inventoryview.dart';
import 'routes/main/mainpage/welcome.dart';
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

        '/login': (context) => const LoginPage(),

        '/Welcome': (context) => const WelcomePage(),

        '/Production': (context) => const ProductionView(),
        '/Production Add': (context) => const ProductionAdd(),
        '/Production Confirm': (context) => const ProductionConfirm(),
        '/Production Details': (context) => const ProductionDetails(),

        '/Inventory': (context) => const InventoryView(),
        '/Inventory Add Product': (context) => const InventoryAddProduct(),

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
