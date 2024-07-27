import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final index;
  const CartProduct({super.key,required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final productDetailsServices = ProductDetailsServices();
  final cartServices = CartServices();

  void increaseQuantity(Product product) {
    productDetailsServices.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product){
    cartServices.removeFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    Product product = Product.fromMap(productCart['product']);
    int quantity = productCart['quantity'];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.imageUrls[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 290,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      style:const TextStyle(
                        fontSize: 16
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left : 10, top: 5),
                    child: Text(
                      "\$${product.price}",
                      style:const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left : 10),
                    child:const Text(
                      "Eligible for free shipping"
                    ),
                  ),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left : 10, top: 5),
                    child:const Text(
                      "In Stock",
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              )
            ]
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: ()=> decreaseQuantity(product),
                      child: Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 32,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.5
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.zero
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 32,
                        child: Text('$quantity')
                      ),
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 32,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
          ),
        )
      ],
    );
  }
}