import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widget/single_product.dart';
import 'package:amazon_clone/model/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
  
  void fetchOrders() async{
    orders= await accountServices.fetchMyOrders(context: context);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return orders == null ?
    const Loader()
    :
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15,),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15,),
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 18,
                  color: GlobalVariables.selectedNavBarColor,
                  fontWeight: FontWeight.w600
                ),
              ),
            )
          ],
        ),
        //display orders
        Container(
          height: 170,
          padding: const EdgeInsets.only(left : 10,top : 20,right: 0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: orders!.length,
            itemBuilder: (context,index){
              return SingleProduct(image: orders![index].products[0].imageUrls[0],);
            }
          ),
        )
      ],
    );
  }
}