import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm>
    with AutomaticKeepAliveClientMixin<SignInForm> {
  //doesn't get rebuilt
  @override
  bool get wantKeepAlive => true;
  bool attemptedSubmit = false;
  bool showPassword = false;
  String passButton = 'Show';
  final _formKey = GlobalKey<FormState>();

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final scrollcontroller = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerEmail.dispose();
    controllerPassword.dispose();
    scrollcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        controller: scrollcontroller,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 15),
              //email label
              Container(
                width: queryData.size.width,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: const Text(
                  "Email",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              //email field
              Container(
                width: queryData.size.width,
                height: formHeight,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextFormField(
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  cursorWidth: 1,
                  maxLength: 128,
                  cursorHeight: cursorHeight,
                  onChanged: (value) {
                    if (attemptedSubmit) {
                      setState(() {
                        _formKey.currentState!.validate();
                      });
                    }
                  },
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: formDecoration(),

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' ';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Email is not valid';
                    }
                    if (value.length > 128) {
                      return 'Email must be no more than 128 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 0),
              Row(
                children: [
                  //password label
                  Container(
                    width: 0.5 * queryData.size.width,
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: const Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              //password field
              Container(
                height: formHeight,
                width: queryData.size.width,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Stack(children: <Widget>[
                  TextFormField(
                    controller: controllerPassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: showPassword ? false : true,
                    enableSuggestions: false,
                    autocorrect: false,
                    maxLength: 128,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: cursorHeight,
                    //when the user presses the enter key, the form is submitted
                    onFieldSubmitted: (value) async {
                      submitfunction();
                    },
                    onChanged: (value) {
                      if (attemptedSubmit) {
                        setState(() {
                          _formKey.currentState!.validate();
                        });
                      }
                    },
                    //inputFormatters: <TextInputFormatter>[
                    //FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), //todo if they are crashing my shit, implement strict regex for passwords
                    //],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),

                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: formDecoration(),

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' ';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (value.length > 128) {
                        return 'Password must be no more than 128 characters';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: 40,
                      width: 70,
                      child: TextButton(
                          style: ElevatedButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            primary: Colors.transparent,
                            onPrimary: Colors.black,
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!showPassword) {
                                showPassword = true;
                                passButton = 'Hide';
                              } else {
                                showPassword = false;
                                passButton = 'Show';
                              }
                            });
                          },
                          child: Text(passButton)),
                    ),
                  ),
                ]),
              ),
              //sign in button
              const SizedBox(height: 20),
              Container(
                width: queryData.size.width,
                height: buttonHeight,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFeb1700),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(500)),
                    textStyle: TextStyle(
                        fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    submitfunction();
                  },
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  submitfunction() async {
    attemptedSubmit = true;
    if (_formKey.currentState!.validate()) {
      final signinResponse =
          await signin(controllerEmail.text, controllerPassword.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //address found; change to main page
      if (signinResponse.statusCode == 200) {
        userJwtToken = jsonDecode(signinResponse.body)['jwtToken'];
        await prefs.setString('jwt', userJwtToken);
        Navigator.pushReplacementNamed(context, '/');
      } else if (signinResponse.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password does not match account.')),
        );
      } else if (signinResponse.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email does not exist in system.')),
        );
      }
      //else if 405, email unverified
      else if (signinResponse.statusCode == 405) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is not verified.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error logging in. Please try again later.')),
        );
      }
    }
  }

  Future<http.Response> signin(email, password) async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}user/login?email=$email&password=$password'),
        headers: {"api": xapikey, "jwt": ""},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}
