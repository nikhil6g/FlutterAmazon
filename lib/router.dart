import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/Auth/Screen/auth_screen.dart';
import 'package:amazon_clone/features/home/screen/home_screen.dart';
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
    case HomeScreen.routeName : 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const HomeScreen(),
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