import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers.dart';
import 'package:http/http.dart' as http;

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with AutomaticKeepAliveClientMixin<VerifyEmailPage> {
  @override
  bool get wantKeepAlive => true;
  bool attemptedSubmit = false;
  final _formKey = GlobalKey<FormState>();
  var maskFormatter =
      MaskTextInputFormatter(mask: '###-###', filter: {"#": RegExp(r'[0-9]')});

  final controllerVCode = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerVCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: const Text('Verify Email'),
            automaticallyImplyLeading: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: queryData.size.width,
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Center(
                  child: Text(
                    'Email: $verifyEmail',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: queryData.size.width,
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                child: const Center(
                  child: Text(
                    'Enter the 6-digit verification code that was sent to your email.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                height: formHeight,
                width: 200,
                margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controllerVCode,
                    textAlign: TextAlign.center,
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
                    inputFormatters: <TextInputFormatter>[
                      maskFormatter,
                    ],
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: cursorHeight,
                    autofocus: true,
                    maxLength: 128,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),

                    decoration: formDecoration(),

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' ';
                      }
                      if (value.length > 128) {
                        return 'The code provided is invalid.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: BottomAppBar(
              color: Colors.white,
              child: Container(
                width: queryData.size.width,
                height: buttonHeight,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 25),
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
                  child: const Text('Submit'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  submitfunction() async {
    attemptedSubmit = true;
    if (_formKey.currentState!.validate()) {
      final verifyResponse = await verify(
        verifyEmail,
        controllerVCode.text.replaceAll('-', ''),
      );

      if (verifyResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userJwtToken = jsonDecode(verifyResponse.body)['jwtToken'];
        await prefs.setString('jwt', userJwtToken);
        //print(jsonDecode(verifyResponse.body)['jwtToken']);
        noAddress = true;
        Navigator.pushReplacementNamed(context, '/main');
      } else if (verifyResponse.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Token was expired. A new one has been sent to your email.')));
      } else if (verifyResponse.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The code is invalid.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error verifying email. Please try again later.')),
        );
      }
    }
  }

  Future<http.Response> verify(email, token) async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}user/confirm?email=$email&token=$token'),
        headers: {"api": rushHourApiKey, "jwt": ""},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}
