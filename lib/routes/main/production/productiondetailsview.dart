// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../helpers.dart';

class ProductionDetails extends StatefulWidget {
  const ProductionDetails({Key? key}) : super(key: key);

  @override
  State<ProductionDetails> createState() => _ProductionDetailsState();
}

class _ProductionDetailsState extends State<ProductionDetails> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        userData.currentPage = 'Production';
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Lot #${userData.currentLot}',
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
              userData.currentPage = 'Production';
              Navigator.of(context).pop();
            },
          ),
          //end button
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.print_rounded,
                color: Colors.grey,
                size: 30,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: productionMap[userData.currentLot].length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == productionMap[userData.currentLot].length) {
              if (lotMap.firstWhere((x) => x['id'] == userData.currentLot)[
                          'isConfirmed'] >
                      0 ||
                  !userData.accessInventory) {
                return Container();
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                    ),
                    onPressed: () async {
                      for (var production
                          in productionMap[userData.currentLot]) {
                        if (!production['isChecked']) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please check all boxes.'),
                            duration: Duration(seconds: 2),
                          ));
                          return;
                        }
                      }
                      final productionRejectResponse = await productionreject(
                        userData.currentLot,
                      );
                      if (productionRejectResponse.statusCode != 200) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Production reject failed'),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        //if the server response is 200, show a snackbar to show that the production was added successfully
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Production rejected successfully'),
                          duration: Duration(seconds: 2),
                        ));
                        //navigate pop
                        Navigator.pushReplacementNamed(context, '/Production');
                      }
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
                      for (var production
                          in productionMap[userData.currentLot]) {
                        if (!production['isChecked']) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please check all boxes.'),
                            duration: Duration(seconds: 2),
                          ));
                          return;
                        }
                      }
                      final productionConfirmResponse =
                          await productionconfirm(userData.currentLot);
                      if (productionConfirmResponse.statusCode != 200) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Production confirm failed'),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        //if the server response is 200, show a snackbar to show that the production was added successfully
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Production confirmed successfully'),
                          duration: Duration(seconds: 2),
                        ));
                        //navigate pop
                        Navigator.pushReplacementNamed(context, '/Production');
                      }
                    },
                    child: const Text('CONFIRM'),
                  ),
                ],
              );
            }
            if (index == productionMap[userData.currentLot].length + 1) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Production Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //submitted by, submit timestamp, checked by, check time
                  Text(
                    'Submitted by: ${userMap.firstWhere((x) => x['id'] == lotMap.firstWhere((x) => x['id'] == userData.currentLot)['userID'])['firstName']} ${userMap.firstWhere((x) => x['id'] == lotMap.firstWhere((x) => x['id'] == userData.currentLot)['userID'])['lastName']}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Submission time: ${DateTime.fromMillisecondsSinceEpoch(lotMap.firstWhere((x) => x['id'] == userData.currentLot)['createdAt'])}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  lotMap.firstWhere((x) => x['id'] == userData.currentLot)[
                              'confirmID'] !=
                          0
                      ? Text(
                          'Checked by: ${userMap.firstWhere((x) => x['id'] == lotMap.firstWhere((x) => x['id'] == userData.currentLot)['confirmID'])['firstName']} ${userMap.firstWhere((x) => x['id'] == lotMap.firstWhere((x) => x['id'] == userData.currentLot)['confirmID'])['lastName']}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                  lotMap.firstWhere((x) => x['id'] == userData.currentLot)[
                              'confirmID'] !=
                          0
                      ? Text(
                          'Check time: ${DateTime.fromMillisecondsSinceEpoch(lotMap.firstWhere((x) => x['id'] == userData.currentLot)['updatedAt'])}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              );
            }
            return Card(
              child: ListTile(
                leading: SizedBox(
                    //set width for half the screen
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                        productMap.firstWhere((x) =>
                            x['id'] ==
                            productionMap[userData.currentLot][index]
                                ['productID'])['name'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
                title: Text(
                    productionMap[userData.currentLot][index]['quantity']
                        .toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                //trailing should be a checkbox with a value of true or false
                trailing: lotMap.firstWhere((x) =>
                            x['id'] == userData.currentLot)['isConfirmed'] ==
                        1
                    ? Checkbox(
                        value: true,
                        onChanged: (bool? value) {},
                      )
                    : !userData.accessInventory
                        ? Checkbox(
                            value: false,
                            onChanged: (bool? value) {},
                          )
                        : lotMap.firstWhere((x) =>
                                    x['id'] ==
                                    userData.currentLot)['isConfirmed'] ==
                                0
                            ? Checkbox(
                                value: productionMap[userData.currentLot][index]
                                        ['isChecked'] ??
                                    false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    productionMap[userData.currentLot][index]
                                        ['isChecked'] = value!;
                                  });
                                },
                              )
                            : Checkbox(
                                value: false, onChanged: (bool? value) {}),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<http.Response> productionconfirm(lotNumber) async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}production/confirmproduction?lotNumber=$lotNumber'),
        headers: {"api": xapikey, "jwt": userData.jwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }

  Future<http.Response> productionreject(lotNumber) async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}production/rejectproduction?lotNumber=$lotNumber'),
        headers: {"api": xapikey, "jwt": userData.jwtToken},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
  }
}
