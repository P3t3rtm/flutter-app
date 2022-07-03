import 'package:makemyown/routes/helpers.dart';
import 'package:flutter/material.dart';

class InventoryProduct extends StatefulWidget {
  const InventoryProduct({Key? key}) : super(key: key);
  @override
  State<InventoryProduct> createState() => _InventoryProductState();
}

//todo allow editing of all fields except id

class _InventoryProductState extends State<InventoryProduct> {
  bool isEditing = false;
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
              icon: isEditing
                  ? Icon(
                      Icons.save_as_outlined,
                      size: 30,
                      color: themeColor,
                    )
                  : Icon(
                      Icons.mode_edit_outlined,
                      size: 30,
                      color: themeColor,
                    ),
              onPressed: () {
                isEditing = !isEditing;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
