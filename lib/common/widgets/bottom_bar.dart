import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/screen/account_screen.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screen/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName='/real-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page=0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth =5;
  List<Widget> pages =[
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body:pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        items:[
          //home page
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page ==0 ? GlobalVariables.selectedNavBarColor: GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  )
                )
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: ''
          ),
          //profile
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1 ? GlobalVariables.selectedNavBarColor: GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  )
                )
              ),
              child: const Icon(Icons.person_outlined),
            ),
            label: ''
          ),
          //for cart
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page ==2 ? GlobalVariables.selectedNavBarColor: GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  )
                )
              ),
              child: badges.Badge(
                badgeStyle:const badges.BadgeStyle(
                  elevation: 0,
                  badgeColor: Colors.white,
                ),
                badgeContent: Text('$userCartLen'),

                child:const Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: ''
          ),
        ]
      ),
    );
  }
}