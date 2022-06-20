import 'package:flutter/material.dart';
import 'package:makemyown/routes/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({Key? key}) : super(key: key);

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: queryData.size.width * 0.75,
      child: SafeArea(
        top: false,
        child: Drawer(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: const Text('Settings',
                  style: TextStyle(
                    fontSize: 25,
                  )),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          mainIsUSD ? mainIsUSD = false : mainIsUSD = true;
                        });
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.attach_money_rounded,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'BZD',
                                style: TextStyle(
                                    color:
                                        mainIsUSD ? Colors.black : themeColor,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          Switch(
                            activeColor: themeColor,
                            activeTrackColor: Colors.red.shade100,
                            inactiveThumbColor: themeColor,
                            inactiveTrackColor: Colors.red.shade100,
                            value: mainIsUSD,
                            onChanged: (bool val) {
                              setState(() {
                                mainIsUSD = val;
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'USD',
                              style: TextStyle(
                                  color: mainIsUSD ? themeColor : Colors.black,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushReplacementNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Edit Address',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.phone_outlined,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Edit Phone',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.headset_mic_outlined,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Customer Service',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.wifi_protected_setup_rounded,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Become a Partner',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.help_outline_rounded,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'FAQs',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.text_snippet_outlined,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Terms of Service',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black12,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    height: 55,
                    child: TextButton(
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/auth');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 15),
                          Icon(
                            Icons.privacy_tip_outlined,
                            color: Colors.orangeAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              bottom: true,
              child: BottomAppBar(
                color: Colors.white,
                child: SizedBox(
                  height: 65,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 55,
                        child: TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            userJwtToken = '';
                            await prefs.setString('jwt', '');
                            Navigator.pushReplacementNamed(context, '/auth');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.red,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              SizedBox(width: 25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
