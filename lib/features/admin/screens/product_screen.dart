import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  void navigateToVoidAddProduct(){
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:const Center(
        child: Text('product'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip:  'Add a product',
        backgroundColor:const Color.fromARGB(255, 29, 201, 192),
        onPressed: navigateToVoidAddProduct,
        child:const Icon(Icons.add)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}