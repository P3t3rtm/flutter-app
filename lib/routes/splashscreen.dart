import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers.dart';
import 'package:http/http.dart' as http;

//secondary loading screen example implementation
//https://github.com/jonbhanson/flutter_native_splash/blob/master/example/lib/main.dart

//todo find file: flutter_native_splash.yaml and change the image to the new image
//run this command in console to update splash screen image
//flutter pub run flutter_native_splash:create

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //await prefs.setString('jwt', ''); //todo remove this line after testing

    userJwtToken = (prefs.getString('jwt') ?? "");

    //_hasAddress = false; // remove this line after testing
    //return Navigator.of(context).pushReplacementNamed('/main');

    if (userJwtToken != "") {
      //http auth page, if 200, then go to home page, 201 then add address,
      //202, then edit phone, 203 then edit phone & set noaddress = true, anything else then /auth
      // if (_hasAddress) {
      //   Navigator.of(context).pushReplacementNamed('/main');
      // } else {
      //   Navigator.of(context).pushReplacementNamed('/addaddress');
      // }
      final authResponse = await auth();
      if (authResponse.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else if (authResponse.statusCode == 201) {
        Navigator.of(context).pushReplacementNamed('/addaddress');
      } else if (authResponse.statusCode == 202) {
        Navigator.of(context).pushReplacementNamed('/editphone');
      } else if (authResponse.statusCode == 203) {
        noAddress = true;
        Navigator.of(context).pushReplacementNamed('/editphone');
      } else {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    //await Future.delayed(const Duration(seconds: 5)); //fake delay
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    checkFirstSeen();
  }

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
        Uri.parse(apiUrl + 'user/auth?jwtToken=$userJwtToken'),
        headers: {"api": rushHourApiKey, "jwt": ""},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}
