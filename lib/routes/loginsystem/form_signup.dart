import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../helpers.dart';
import "package:http/http.dart" as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm>
    with AutomaticKeepAliveClientMixin<SignUpForm> {
  //doesn't get rebuilt
  @override
  bool get wantKeepAlive => true;
  bool attemptedSubmit = false;
  bool showPassword = false;
  String passButton = 'Show';
  final _formKey = GlobalKey<FormState>();
  var maskFormatter =
      MaskTextInputFormatter(mask: '###-####', filter: {"#": RegExp(r'[0-9]')});

  final controllerFirstname = TextEditingController();
  final controllerLastname = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPhone = TextEditingController();
  final scrollcontroller = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerFirstname.dispose();
    controllerLastname.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerPhone.dispose();
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
              Row(
                children: [
                  //first name label
                  Container(
                    width: 0.5 * queryData.size.width,
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: const Text(
                      "First Name",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //last name label
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: const Text(
                      "Last Name",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  //first name
                  Container(
                    height: formHeight,
                    width: 0.5 * queryData.size.width,
                    padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child: TextFormField(
                      controller: controllerFirstname,
                      onChanged: (value) {
                        if (attemptedSubmit) {
                          setState(() {
                            _formKey.currentState!.validate();
                          });
                        }
                      },
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9\- ]')),
                      ],
                      cursorColor: Colors.black,
                      cursorWidth: 1,
                      cursorHeight: cursorHeight,
                      maxLength: 128,
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
                        if (value.length > 128) {
                          return 'First name must be no more than 128 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  //last name
                  Container(
                    width: 0.5 * queryData.size.width,
                    height: formHeight,
                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                    child: TextFormField(
                      controller: controllerLastname,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9\- ]')),
                      ],
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
                        if (value.length > 128) {
                          return 'Last name must be no more than 128 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              //email label
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: const Text(
                  "Email",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              //email
              Container(
                height: formHeight,
                width: queryData.size.width,
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

              //password label
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: const Text(
                  "Password",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              //password
              Container(
                width: queryData.size.width,
                height: formHeight,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Stack(children: <Widget>[
                  TextFormField(
                    //enter key to submit form

                    onTap: () {
                      scrollcontroller.animateTo(
                        scrollcontroller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    controller: controllerPassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: showPassword ? false : true,
                    enableSuggestions: false,
                    maxLength: 128,
                    autocorrect: false,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: cursorHeight,
                    //when the user hits enter, submit the form
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
                    //FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    ////todo if they are crashing my shit, implement strict regex for passwords
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
                      ))
                ]),
              ),
              const SizedBox(height: 20),
              //sign up button
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
                  //sign up button on pressed
                  onPressed: () async {
                    submitfunction();
                  },
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ));
  }

  Future<http.Response> signup(
      firstname, lastname, password, email, phone) async {
    try {
      return await http.get(
        Uri.parse(
            '${apiUrl}user/register?firstName=$firstname&lastName=$lastname&password=$password&email=$email'),
        headers: {"api": xapikey, "jwt": ""},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      print(e);
      return http.Response('', 500);
    }
  }

  submitfunction() async {
    attemptedSubmit = true;
    if (_formKey.currentState!.validate()) {
      final signupResponse = await signup(
          controllerFirstname.text,
          controllerLastname.text,
          controllerPassword.text,
          controllerEmail.text,
          controllerPhone.text.replaceAll('-', ''));

      if (signupResponse.statusCode == 200 ||
          signupResponse.statusCode == 401) {
        verifyEmail = controllerEmail.text;
        Navigator.pushNamed(context, '/verifyemail');
      } else if (signupResponse.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The email is already in use.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error signing up. Please try again later.')),
        );
      }
    }
  }
}
