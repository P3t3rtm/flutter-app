// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers.dart';
import 'package:http/http.dart' as http;

//todo add biometric unlock after 1 hour of inactivity

//this page is used to show the splash screen
//also used to check if user's jwt token is valid, meaning user is logged in or not
//if user is logged in, then he/she is redirected to main page
//if user is not logged in, then he/she is redirected to login page

//secondary loading screen example implementation
//https://github.com/jonbhanson/flutter_native_splash/blob/master/example/lib/main.dart

//todo find file: flutter_native_splash.yaml and change the image to the new image
//run this command in console to update splash screen image
//flutter pub run flutter_native_splash:create

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //await prefs.setString('jwt', ''); //todo remove this line after testing

    userJwtToken = (prefs.getString('jwt') ?? "");
    userCurrentPage = (prefs.getString('page') ??
        "Production"); //todo implement the rest of this
    if (userJwtToken != "") {
      final authResponse = await auth();
      if (authResponse.statusCode == 200) {
        // todo maybe implement refresh tokens?
        // if(prefs.getString('refresh') != authResponse.body) {
        //
        // }
        // userRefreshToken = authResponse.body;

        logaction("User authenticated.");
        Navigator.of(context).pushReplacementNamed('/$userCurrentPage');
        return;
      }
    }
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)); //todo remove fake delay
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    checkFirstSeen();
  }

//this is the loading screen graphics
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: queryData.size.width,
              ),
              SizedBox(
                width: 0.15 * queryData.size.width,
                height: 0.15 * queryData.size.width,
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Loading.."),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> auth() async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}user/auth'),
        headers: {"api": xapikey, "jwt": userJwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}
