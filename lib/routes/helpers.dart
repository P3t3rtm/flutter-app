import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

double buttonFontSize = 16.0;
double buttonHeight = 40.0;
double formHeight = 65.0;
double cursorHeight = 23.0;

Color themeColor = const Color.fromARGB(255, 57, 173, 53);

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

//productinadd list of products to be added to the production

//map of lists of maps
var productionMap = {};
var productionAddMap = {};

//list of maps
var lotMap = [];
var userMap = [];
var productMap = [];

CurrentUser userData = CurrentUser(
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
  0,
);

Future<http.Response> fetchproduction(lotNumber) async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}production/fetchproduction?lotNumber=$lotNumber'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

Future<http.Response> fetchlots([lastLot]) async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}production/fetchlots?lastLot=${lastLot ?? ''}'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
}

Future<http.Response> fetchproducts() async {
  try {
    return await http.get(
      Uri.parse('${apiUrl}inventory/fetchproducts'),
      headers: {"api": xapikey, "jwt": userData.jwtToken},
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    return http.Response('', 500);
  }
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
  int currentLot;

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
    this.currentLot,
  );
}
