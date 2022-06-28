import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makemyown/routes/main/sidemenu/drawerleftpage.dart';

import '../../helpers.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Welcome',
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          drawer: const LeftDrawer(),
          body: const Center(
            child: Text('Welcome.'),
          ),
        ),
      ),
    );
  }
}
