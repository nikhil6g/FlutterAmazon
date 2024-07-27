// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/model/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class CartServices{
  void removeFromCart({
    required BuildContext context,
    required Product product
  }) async {
    try{
      
      final userProvider = Provider.of<UserProvider>(context,listen: false);
      //similar to get request delete request doesn't have a body
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),  
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',   //this header part is used for as we using a middleware in index.js
          'x-auth-token' :  userProvider.user.token             //file named express.json()
        }
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: (){
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body)['cart']
          );
          userProvider.setUserFromModel(user);
          showSnackBar(context, "Successfully removed from cart");
        }
      );
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }
}