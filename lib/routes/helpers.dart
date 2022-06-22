import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//helper functions and variables to be used in the app

double buttonFontSize = 16.0;
double buttonHeight = 40.0;
double formHeight = 65.0;
double cursorHeight = 23.0;

Color themeColor = Color.fromARGB(255, 57, 173, 53);

bool mainCartHasItems = true;
bool mainIsUSD = false;

bool mainPageRestaurant = true;
bool mainPageSearch = false;
bool mainPageOrders = false;

String userFirstName = '';
String userLastName = '';
String userEmail = '';
String userJwtToken = '';
String userRefreshToken = '';
String userCurrentPage = '';

//TODO make new keys and hide from github
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
