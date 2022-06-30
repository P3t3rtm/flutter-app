import 'package:makemyown/routes/helpers.dart';
import 'package:flutter/material.dart';

class InventoryEditProduct extends StatefulWidget {
  const InventoryEditProduct({Key? key}) : super(key: key);
  @override
  State<InventoryEditProduct> createState() => _InventoryEditProductState();
}

//todo allow editing of all fields except id

class _InventoryEditProductState extends State<InventoryEditProduct> {
  @override
  void initState() {
    super.initState();
    userData.currentPage = 'Edit Product';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        userData.currentPage = 'Product Details';
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Edit Product',
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
              userData.currentPage = 'Product Details';
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
