import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/Auth/Screen/auth_screen.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/home/screen/category_deals_screen.dart';
import 'package:amazon_clone/features/home/screen/home_screen.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case AuthScreen.routeName : 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const AuthScreen(),
      );
    case BottomBar.routeName :
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const BottomBar(),
      );
    case AdminScreen.routeName :
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const AdminScreen(),
      );
    case HomeScreen.routeName : 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const HomeScreen(),
      );
    case AddProductScreen.routeName : 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const AddProductScreen(),
      );
    case ProductDetailsScreen.routeName : 
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> ProductDetailsScreen(
          product: product,
        ),
      );
    case CategoryDealsScreen.routeName : 
      var category = routeSettings.arguments as String; //
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName : 
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    default : 
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        )
      );
  }
}