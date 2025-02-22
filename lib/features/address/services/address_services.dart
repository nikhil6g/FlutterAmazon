// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/model/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response res =
          await http.post(Uri.parse('$uri/api/save-user-address'),
              headers: <String, String>{
                'Content-Type':
                    'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
                'x-auth-token':
                    userProvider.user.token //file named express.json()
              },
              body: jsonEncode({'address': address}));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User user = userProvider.user.copyWith(
              address: jsonDecode(res.body)['address'],
            );
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //placing a order
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalAmount,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/order'),
          headers: <String, String>{
            'Content-Type':
                'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
            'x-auth-token': userProvider.user.token //file named express.json()
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'totalPrice': totalAmount,
            'address': address,
          }));
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'your order has been placed');
            User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
