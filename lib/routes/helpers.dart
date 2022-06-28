import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import http
import 'package:http/http.dart' as http;

//helper functions and variables to be used in the app

//data has a structure of
// {
// 	"values": [
// 		{
// 			"productID": 1,
// 			"quantity": 15
// 		},
// 		{
// 			"productID": 2,
// 			"quantity": 15575
// 		}
// 	]
// }
var data = {};

double buttonFontSize = 16.0;
double buttonHeight = 40.0;
double formHeight = 65.0;
double cursorHeight = 23.0;

Color themeColor = const Color.fromARGB(255, 57, 173, 53);

String userFirstName = '';
String userLastName = '';
String userEmail = '';
String userJwtToken = '';
String userRefreshToken = '';
String userCurrentPage = '';
int productionCurrentLot = 0;

//todo make new keys and hide from github
String xapikey = 'Z81jFHhfuq712hadaAjudqoabbffhgfjqi71K';

// //global variables
// bool isLoading = false;
// bool emailUsed = false;
String apiUrl =
    "http://10.0.2.2:1337/"; //todo change these to the ip address of the server
String imgUrl = "http://10.0.2.2:1337/zfoilhfakh5wadkn/";
String verifyEmail = '';
late MediaQueryData queryData;

formDecoration() {
  return InputDecoration(
    counterText: "",
    helperText: ' ',
    border: InputBorder.none,
    filled: true,
    fillColor: const Color(0xfff7f7f7),
    contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(7),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(7),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(7),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(7),
    ),
  );
}

appTheme() {
  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

Future<http.Response> logaction(logAction) async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}data/addlog?logAction=$logAction'),
      headers: {"api": xapikey, "jwt": userJwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

//used in productionview and productiondetailsview
var lotMap = {};
List<Production> productions = [];
List<Product> products = [];

Future<http.Response> fetchproduction() async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}production/fetchproduction'),
      headers: {"api": xapikey, "jwt": userJwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

Future<http.Response> fetchproducts() async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}production/fetchproducts'),
      headers: {"api": xapikey, "jwt": userJwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

class Product {
  final String name;
  final String category;
  final int id;

  Product(this.name, this.category, this.id);

  Product.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        category = json['category'],
        id = json['id'];

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'category': category,
  //       'id': id,
  //     };
}

class Production {
  final int id;
  final int lotNumber;
  final int quantity;
  final int productID;
  final int userID;
  final int timestamp;
  final bool isConfirmed;

  Production(this.lotNumber, this.quantity, this.productID, this.userID,
      this.timestamp, this.id, this.isConfirmed);

  Production.fromJson(Map<String, dynamic> json)
      : lotNumber = json['lotNumber'],
        quantity = json['quantity'],
        id = json['id'],
        productID = json['productID'],
        userID = json['userID'],
        timestamp = json['createdAt'],
        isConfirmed = json['isConfirmed'];
}
