import 'package:flutter/material.dart';

import '../helpers.dart';

class RightDrawer extends StatefulWidget {
  const RightDrawer({Key? key}) : super(key: key);

  @override
  _RightDrawerState createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        top: false,
        child: Drawer(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: const Text('My Order',
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
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              bottom: true,
              child: BottomAppBar(
                color: Colors.white,
                child: Container(
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
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {},
                    child: const Text('Place Order'),
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
