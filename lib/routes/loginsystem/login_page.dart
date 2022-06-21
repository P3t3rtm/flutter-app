import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers.dart';
import 'form_signin.dart';
import 'form_signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: DefaultTabController(
          length: 2,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: const Text('My Account'),
                automaticallyImplyLeading: false,
                bottom: const TabBar(
                  indicatorColor: Colors.black,
                  indicatorWeight: 3,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              body: Stack(children: const <Widget>[
                TabBarView(
                  children: [
                    //sign up page================================
                    SignUpForm(),
                    //sign in page================================
                    SignInForm(),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
