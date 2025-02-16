// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/model/order.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct(
      {required BuildContext context,
      required String name,
      required String description,
      required double price,
      required double quantity,
      required String category,
      required List<File> images,
      required VoidCallback onSuccess}) async {
    try {
      //because we are in shared cluster on mongodb so we can store only 512 mb data
      //that's why we don't store these images files on mongodb
      //we use cloudinary for that , This package allows you to upload media files directly to cloudinary, without exposing your apiKey or secretKey.
      final cloudinary = CloudinaryPublic(
          'dyv42n1qk', //cloudname
          'kslahkl' //uploadPreset
          );
      List<String> imageUrls = [];

      for (int j = 0; j < images.length; j++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[j].path, folder: name));
        imageUrls.add(res.secureUrl);
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        imageUrls: imageUrls,
        category: category,
      );

      http.Response res = await http.post(Uri.parse('$uri/admin/add-product'),
          body: product.toJson(),
          headers: <String, String>{
            'Content-Type':
                'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
            'x-auth-token': userProvider.user.token //file named express.json()
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
          'x-auth-token': userProvider.user.token //file named express.json()
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int j = 0; j < jsonDecode(res.body).length; j++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[j],
                ),
              ), //as jsonDecode give object not string , that's why use jsonEncode
            );
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  //for deleteing a product
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        body: jsonEncode({'id': product.id}),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
          'x-auth-token': userProvider.user.token //file named express.json()
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  //for getting all orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  //for changing the order status
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
          'x-auth-token': userProvider.user.token //file named express.json()
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<SalesBase> salesEarning = [];
    List<SalesBase> salesCount = [];
    int totalEarning = 0;
    int totalSellingCount = 0;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
          'x-auth-token': userProvider.user.token //file named express.json()
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          totalSellingCount = response['totalSellingCount'];
          var categoryData = response['categoryData'];
          salesEarning = [
            SalesEarning("Mobiles", categoryData['Mobiles']['earnings']),
            SalesEarning("Essentials", categoryData['Essentials']['earnings']),
            SalesEarning("Appliances", categoryData['Appliances']['earnings']),
            SalesEarning("Books", categoryData['Books']['earnings']),
            SalesEarning("Fashion", categoryData['Fashion']['earnings']),
          ];
          salesCount = [
            SalesCount("Mobiles", categoryData['Mobiles']['sellingCount']),
            SalesCount(
                "Essentials", categoryData['Essentials']['sellingCount']),
            SalesCount(
                "Appliances", categoryData['Appliances']['sellingCount']),
            SalesCount("Books", categoryData['Books']['sellingCount']),
            SalesCount("Fashion", categoryData['Fashion']['sellingCount']),
          ];
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }

    return {
      'salesCount': salesCount,
      'salesEarning': salesEarning,
      'totalEarning': totalEarning,
      'totalSellingCount': totalSellingCount,
    };
  }
}
