import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    double averageRating = 0;
    double totalRating = 0;
    for (int i = 0; i < product.ratings!.length; i++) {
      totalRating += product.ratings![i].rating;
      if (product.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {}
    }
    if (totalRating != 0) {
      averageRating = totalRating / product.ratings!.length;
    }

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
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 290,
                    height: 30,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Stars(
                      rating: averageRating,
                    ),
                  ),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text("Eligible for free shipping"),
                  ),
                  Container(
                    width: 290,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: product.quantity == 0
                        ? const Text(
                            "Out of Stock",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : const Text(
                            "In Stock",
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
