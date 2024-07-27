// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices{
  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
    required VoidCallback onSuccess
  }) async {
    try{
      
      final userProvider = Provider.of<UserProvider>(context,listen: false);

      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        body: jsonEncode({
          'id' : product.id!,
          'rating' : rating
        }),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',   //this header part is used for as we using a middleware in index.js
          'x-auth-token' :  userProvider.user.token             //file named express.json()
        }
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: (){
          onSuccess();
        }
      );
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
}