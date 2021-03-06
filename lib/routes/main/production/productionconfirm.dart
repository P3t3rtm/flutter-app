// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makemyown/routes/helpers.dart';

class ProductionConfirm extends StatefulWidget {
  const ProductionConfirm({Key? key}) : super(key: key);
  @override
  State<ProductionConfirm> createState() => _ProductionConfirmState();
}

class _ProductionConfirmState extends State<ProductionConfirm> {
  //override init state
  @override
  void initState() {
    super.initState();
    userData.currentPage = 'Production Confirm';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        userData.currentPage = 'Production Add';
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Production Confirm',
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          //leading go back button,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: themeColor,
              size: 30,
            ),
            onPressed: () {
              userData.currentPage = 'Production Add';
              Navigator.pop(context);
            },
          ),
        ),
        //the body should have the content of the 'data' variable as a listview builder and the last item should be 2 buttons: 'confirm' and 'cancel'
        body: ListView.builder(
          itemCount: productionAddMap['values'].length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == productionAddMap['values'].length) {
              //return 2 buttons: 'confirm' and 'cancel'
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                        ),
                        onPressed: () {
                          userData.currentPage = 'Production Add';
                          Navigator.of(context).pop();
                        },
                        child: const Text('REJECT'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: themeColor,
                          padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                        ),
                        onPressed: () async {
                          //for all data['values'][index]['isChecked'], make sure it is true
                          for (int i = 0;
                              i < productionAddMap['values'].length;
                              i++) {
                            if (productionAddMap['values'][i]['isChecked'] ==
                                false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Please check all items before confirming'),
                                duration: Duration(seconds: 2),
                              ));
                              return;
                            }
                          }
                          final logactionResponse =
                              await logaction('Production Add.');
                          if (logactionResponse.statusCode != 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Logaction failed'),
                              duration: Duration(seconds: 2),
                            ));
                          }

                          final productionaddResponse =
                              await productionadd(productionAddMap);
                          if (productionaddResponse.statusCode != 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Production Add failed'),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            //if the server response is 200, show a snackbar to show that the production was added successfully
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Production added successfully'),
                              duration: Duration(seconds: 2),
                            ));
                            //navigate pop
                            Navigator.pushReplacementNamed(
                                context, '/Production');
                          }
                        },
                        child: const Text('CONFIRM'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              );
            }
            return Card(
              child: ListTile(
                leading: SizedBox(
                    //set width for half the screen
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(productionAddMap['values'][index]['name'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                title: Text(
                    productionAddMap['values'][index]['quantity'].toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                //trailing should be a checkbox with a value of true or false
                trailing: Checkbox(
                  value:
                      productionAddMap['values'][index]['isChecked'] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      productionAddMap['values'][index]['isChecked'] = value!;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //http://192.168.100.69:1337/production/produce?productID=2&quantity=10000&logID=69&userID=68&comments=lulllz&lotNumber=55
  Future<http.Response> productionadd(data) async {
    try {
      return await http
          .post(
            Uri.parse('${apiUrl}production/addproduction'),
            headers: {"api": xapikey, "jwt": userData.jwtToken},
            //the body will be a json array of productID and quantity
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}
