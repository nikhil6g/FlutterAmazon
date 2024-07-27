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


class SearchServices{

  //search products for given query
  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery
  }) async{
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    List<Product> productList = [];
    try{
      http.Response res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
        headers: <String,String>{
          'Content-Type' : 'application/json; charset=UTF-8',   //this header part is used for as we using a middleware in index.js
          'x-auth-token' :  userProvider.user.token             //file named express.json()
        }
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: (){
          for(int j=0;j<jsonDecode(res.body).length;j++){
            productList.add(
              Product.fromJson(jsonEncode((jsonDecode(res.body))[j])) //as jsonDecode give object not string , that's why use jsonEncode
            );
          }
        }
      );
    }catch(e){
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}