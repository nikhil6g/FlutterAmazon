// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/model/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices {
  //for subscribing to notification when product is available
  void notifyMe({
    required BuildContext context,
    required String productId,
    required VoidCallback onSuccess,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        showSnackBar(context, "Failed to get FCM token.");
        return;
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/notify-me'),
        body: jsonEncode({
          'userId': userProvider.user.id,
          'productId': productId,
          'fcmToken': fcmToken,
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
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> checkInitialSubscriptionForNotifyMe({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user.id;
      http.Response res = await http.get(
        Uri.parse(
            '$uri/api/notifications/check-subscription?userId=$userId&productId=$productId'),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', //this header part is used for as we using a middleware in index.js
          'x-auth-token': userProvider.user.token //file named express.json()
        },
      );

      final decodedData = jsonDecode(res.body);
      return decodedData['subscribed'];
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  //for giving rating
  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
    required VoidCallback onSuccess,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        body: jsonEncode({'id': product.id!, 'rating': rating}),
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
      showSnackBar(context, e.toString());
    }
  }

  //for add to cart
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        body: jsonEncode({
          'id': product.id!,
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
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(context, "Successfully added to cart");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
