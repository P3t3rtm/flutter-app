import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

double buttonFontSize = 16.0;
double buttonHeight = 40.0;
double formHeight = 65.0;
double cursorHeight = 23.0;

Color themeColor = const Color.fromARGB(255, 57, 173, 53);

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

Future<http.Response> httpfetchusers() async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}data/fetchusers'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

Future<http.Response> logaction(logAction) async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}data/addlog?logAction=$logAction'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

//used in productionview and productiondetailsview ===========================================================================================

var data = {}; //productinadd list of products to be added to the production
var lotMap = {};
var userMap = {};
var quantityMap = {};
CurrentUser userData = CurrentUser(
//  String firstName,
//   String lastName,
//   int id,
//   int colorID,
//   String email,
//   String jwtToken,
//   String refreshToken,
//   String currentPage,
//   bool isAdmin,
//   bool accessProduction,
//   bool accessInventory,
//   bool accessInvoicing,
//   bool accessAccounting,
  '',
  '',
  0,
  0,
  '',
  '',
  0,
  '',
  false,
  false,
  false,
  false,
  false,
);

List<Production> productions = [];
List<Product> products = [];
List<User> users = [];

Future<http.Response> fetchproduction() async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}production/fetchproduction'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

Future<http.Response> fetchproducts() async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}production/fetchproducts'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
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
  final int confirmTime;

  Production(this.lotNumber, this.quantity, this.productID, this.userID,
      this.timestamp, this.id, this.isConfirmed, this.confirmTime);

  Production.fromJson(Map<String, dynamic> json)
      : lotNumber = json['lotNumber'],
        quantity = json['quantity'],
        id = json['id'],
        productID = json['productID'],
        userID = json['userID'],
        timestamp = json['createdAt'],
        isConfirmed = json['isConfirmed'],
        confirmTime = json['updatedAt'];
}

class User {
  String firstName;
  String lastName;
  int id;
  int colorID;

  User(
    this.firstName,
    this.lastName,
    this.id,
    this.colorID,
  );

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        id = json['id'],
        colorID = json['colorID'];
}

class CurrentUser {
  int id;
  String firstName;
  String lastName;
  String email;
  int colorID;
  int refreshToken;
  String jwtToken;
  String currentPage;
  bool isAdmin;
  bool accessProduction;
  bool accessInventory;
  bool accessInvoicing;
  bool accessAccounting;

  CurrentUser(
    this.firstName,
    this.lastName,
    this.id,
    this.colorID,
    this.email,
    this.jwtToken,
    this.refreshToken,
    this.currentPage,
    this.isAdmin,
    this.accessProduction,
    this.accessInventory,
    this.accessInvoicing,
    this.accessAccounting,
  );

  CurrentUser.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        id = json['id'],
        colorID = json['colorID'],
        email = json['email'],
        jwtToken = json['jwtToken'],
        refreshToken = json['refreshToken'],
        currentPage = json['currentPage'],
        isAdmin = json['isAdmin'],
        accessProduction = json['accessProduction'],
        accessInventory = json['accessInventory'],
        accessInvoicing = json['accessInvoicing'],
        accessAccounting = json['accessAccounting'];
}
