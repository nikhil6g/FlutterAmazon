import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/add_or_update_product_screen.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  double myRating = 0;

  bool isSubscribedForNotification = false;
  late Product _currentProduct;

  String? productCategory;

  bool isLoader = false;
  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;

    for (int i = 0; i < _currentProduct.ratings!.length; i++) {
      if (_currentProduct.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = _currentProduct.ratings![i].rating;
      }
    }

    if (_currentProduct.quantity == 0) {
      isLoader = true;
      checkSubscriptionForNotification();
    }
  }

  void checkSubscriptionForNotification() async {
    isSubscribedForNotification =
        await productDetailsServices.checkInitialSubscriptionForNotifyMe(
            context: context, productId: _currentProduct.id!);
    setState(() {
      isLoader = false;
    });
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToPrdouctUpdationPage(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      AddOrUpdateProductScreen.routeName,
      arguments: product,
    );
  }

  void addToCart() {
    productDetailsServices.addToCart(
      context: context,
      product: _currentProduct,
    );
  }

  void notifyMe() {
    productDetailsServices.notifyMe(
      context: context,
      productId: _currentProduct.id!,
      onSuccess: () {
        setState(() {
          isSubscribedForNotification = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return isLoader
        ? const Loader()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: GlobalVariables.appBarGradient),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        margin: const EdgeInsets.only(left: 15),
                        child: Material(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 1,
                          child: TextFormField(
                            onFieldSubmitted: navigateToSearchScreen,
                            decoration: InputDecoration(
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 23,
                                  ),
                                ),
                              ),
                              hintText: 'Search Amazon.in',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(top: 10),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide:
                                    BorderSide(color: Colors.black38, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 42,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                          const Icon(Icons.mic, color: Colors.black, size: 25),
                    )
                  ],
                ),
                actions: [
                  if (user.type == 'admin')
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        navigateToPrdouctUpdationPage(context, _currentProduct);
                      },
                    ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_currentProduct.id!),
                        Stars(
                          rating: widget.product.avgRating == null
                              ? 0
                              : widget.product.avgRating!,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Text(
                      _currentProduct.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CarouselSlider(
                    items: _currentProduct.imageUrls.map((i) {
                      return Builder(
                        builder: (BuildContext context) => Image.network(
                          i,
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(viewportFraction: 1, height: 300),
                  ),
                  const SizedBox(height: 10),
                  Container(color: Colors.black12, height: 5),
                  if (user.type == 'admin')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Category: ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: _currentProduct.category,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RichText(
                      text: TextSpan(
                        text: 'Deal Price: ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '\$${_currentProduct.price} only',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      _currentProduct.description,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RichText(
                      text: TextSpan(
                        text: 'Brand : ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: _currentProduct.brand,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (user.type == 'admin')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Available Quantity: ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '${_currentProduct.quantity.toInt()} units',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (user.type == 'admin')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Tags: ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: _currentProduct.tags,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (user.type == 'admin')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Total Sold: ',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: _currentProduct.soldCount.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(color: Colors.black12, height: 5),
                  if (user.type == 'admin')
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomButton(
                        text: 'Edit Product',
                        onTap: () {
                          navigateToPrdouctUpdationPage(
                            context,
                            widget.product,
                          );
                        },
                      ),
                    )
                  else
                    _currentProduct.quantity == 0
                        ? isSubscribedForNotification
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'You will be notified when this product is available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 59, 92, 74),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomButton(
                                  text: 'Notify me when available',
                                  onTap: notifyMe,
                                ),
                              )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
                                    CustomButton(text: 'Buy Now', onTap: () {}),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: CustomButton(
                                  text: 'Add To Cart',
                                  onTap: addToCart,
                                  color: const Color.fromRGBO(254, 216, 19, 1),
                                ),
                              ),
                            ],
                          ),
                  const SizedBox(height: 10),
                  Container(color: Colors.black12, height: 5),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Rate The Product',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  RatingBar.builder(
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    initialRating: myRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: GlobalVariables.secondaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      productDetailsServices.rateProduct(
                        context: context,
                        product: _currentProduct,
                        rating: rating,
                        onSuccess: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
