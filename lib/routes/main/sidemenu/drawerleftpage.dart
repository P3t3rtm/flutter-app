// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

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
              actions: <Widget>[
                Builder(
                  builder: (context) {
                    return IconButton(
                      color: themeColor,
                      icon: const Icon(
                        Icons.menu_open_rounded,
                        size: 33,
                      ),
                      onPressed: () {
                        //close the drawer
                        Navigator.pop(context);
                      },
                    );
                  },
                )
              ],
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: const Text('Menu',
                  style: TextStyle(
                    fontSize: 25,
                  )),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  userData.accessProduction
                      ? const Divider(
                          height: 0,
                          color: Colors.black12,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )
                      : const SizedBox(),
                  userData.accessProduction
                      ? SizedBox(
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/Production');
                            },
                            child: Row(
                              children: const [
                                SizedBox(width: 15),
                                Icon(
                                  Icons.factory_rounded,
                                  color: Colors.orangeAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Production',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  userData.accessInventory
                      ? const Divider(
                          height: 0,
                          color: Colors.black12,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )
                      : const SizedBox(),
                  userData.accessInventory
                      ? SizedBox(
                          height: 55,
                          child: TextButton(
                            onPressed: () async {
                              //Navigator.pushNamed(context, '/auth');
                            },
                            child: Row(
                              children: const [
                                SizedBox(width: 15),
                                Icon(
                                  Icons.inventory_rounded,
                                  color: Colors.orangeAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Inventory',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  userData.accessInvoicing
                      ? const Divider(
                          height: 0,
                          color: Colors.black12,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )
                      : const SizedBox(),
                  userData.accessInvoicing
                      ? SizedBox(
                          height: 55,
                          child: TextButton(
                            onPressed: () async {
                              //Navigator.pushNamed(context, '/auth');
                            },
                            child: Row(
                              children: const [
                                SizedBox(width: 15),
                                Icon(
                                  Icons.note_rounded,
                                  color: Colors.orangeAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Invoicing',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  userData.accessAccounting
                      ? const Divider(
                          height: 0,
                          color: Colors.black12,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )
                      : const SizedBox(),
                  userData.accessAccounting
                      ? SizedBox(
                          height: 55,
                          child: TextButton(
                            onPressed: () async {
                              //Navigator.pushNamed(context, '/auth');
                            },
                            child: Row(
                              children: const [
                                SizedBox(width: 15),
                                Icon(
                                  Icons.bar_chart_outlined,
                                  color: Colors.orangeAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Accounting',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  userData.isAdmin
                      ? const Divider(
                          height: 0,
                          color: Colors.black12,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )
                      : const SizedBox(),
                  userData.isAdmin
                      ? SizedBox(
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
                                      'Logs',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
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
                            userData.jwtToken = '';
                            await prefs.setString('jwt', '');
                            Navigator.pushReplacementNamed(context, '/login');
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
