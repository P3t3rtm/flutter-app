import 'package:flutter/material.dart';
import 'package:makemyown/routes/helpers.dart';
//import http
import 'package:http/http.dart' as http;

class ProductionAdd extends StatefulWidget {
  const ProductionAdd({Key? key}) : super(key: key);

  @override
  State<ProductionAdd> createState() => _ProductionAddState();
}

class _ProductionAddState extends State<ProductionAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Production'),
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Text('Add Production'),
      ),
    );
  }

  Future<http.Response> fetch(email, password) async {
    try {
      return await http.get(
        Uri.parse('${apiUrl}production/fetchproducts'),
        headers: {"api": xapikey, "jwt": ""},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      return http.Response('', 500);
    }
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

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': category,
        'id': id,
      };
}
