// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/Auth/Screen/auth_screen.dart';
import 'package:amazon_clone/model/order.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/orders/me'), headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
        'x-auth-token': userProvider.user.token //file named express.json()
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int j = 0; j < jsonDecode(res.body).length; j++) {
              orderList.add(Order.fromJson(jsonEncode((jsonDecode(res.body))[
                      j])) //as jsonDecode give object not string , that's why use jsonEncode
                  );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("x-auth-token", '');
      Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routeName, (route) => false);
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
