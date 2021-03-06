import 'package:makemyown/routes/helpers.dart';
import 'package:flutter/material.dart';

class InventoryAddProduct extends StatefulWidget {
  const InventoryAddProduct({Key? key}) : super(key: key);
  @override
  State<InventoryAddProduct> createState() => _InventoryAddProductState();
}

class _InventoryAddProductState extends State<InventoryAddProduct> {
  @override
  void initState() {
    super.initState();
    userData.currentPage = 'Add Product';
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
            'Add Product',
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
        ),
      ),
    );
  }
}
