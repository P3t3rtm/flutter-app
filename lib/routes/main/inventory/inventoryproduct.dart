import 'package:makemyown/routes/helpers.dart';
import 'package:flutter/material.dart';

class InventoryProduct extends StatefulWidget {
  const InventoryProduct({Key? key}) : super(key: key);
  @override
  State<InventoryProduct> createState() => _InventoryProductState();
}

class _InventoryProductState extends State<InventoryProduct> {
  @override
  void initState() {
    super.initState();
    userData.currentPage = 'Product Details';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        userData.currentPage = 'Inventory';
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Product Details',
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
              userData.currentPage = 'Inventory';
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit_note_rounded,
                size: 30,
                color: themeColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/Inventory Edit Product');
              },
            ),
          ],
        ),
      ),
    );
  }
}
