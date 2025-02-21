import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
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
  final AdminServices adminServices = AdminServices();
  double averageRating = 0;
  double myRating = 0;
  bool isEditing = false;
  late Product _currentProduct;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String? productCategory;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    nameController.text = _currentProduct.name;
    descriptionController.text = _currentProduct.description;
    priceController.text = _currentProduct.price.toString();
    quantityController.text = _currentProduct.quantity.toString();
    productCategory = _currentProduct.category;

    double totalRating = 0;
    for (int i = 0; i < _currentProduct.ratings!.length; i++) {
      totalRating += _currentProduct.ratings![i].rating;
      if (_currentProduct.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = _currentProduct.ratings![i].rating;
      }
    }
    if (totalRating != 0) {
      averageRating = totalRating / _currentProduct.ratings!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    productDetailsServices.addToCart(
      context: context,
      product: _currentProduct,
    );
  }

  void saveProduct() {
    double newPrice =
        double.tryParse(priceController.text) ?? _currentProduct.price;
    double newQuantity =
        double.tryParse(quantityController.text) ?? _currentProduct.quantity;
    Product updatedProduct = Product(
      name: nameController.text,
      description: descriptionController.text,
      price: newPrice,
      quantity: newQuantity,
      imageUrls: _currentProduct.imageUrls,
      category: productCategory!,
      id: _currentProduct.id,
      ratings: _currentProduct.ratings,
    );
    adminServices.updateProductDetails(
      context: context,
      updatedProduct: updatedProduct,
      onSuccess: () {
        setState(() {
          _currentProduct = updatedProduct;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
      },
    );
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      nameController.text = _currentProduct.name;
      descriptionController.text = _currentProduct.description;
      priceController.text = _currentProduct.price.toString();
      quantityController.text = _currentProduct.quantity.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
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
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1),
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              )
            ],
          ),
          actions: [
            if (user.type == 'admin')
              IconButton(
                icon: Icon(isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (isEditing) {
                    saveProduct();
                  } else {
                    setState(() {
                      isEditing = true;
                    });
                  }
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
                  Stars(rating: averageRating)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: user.type == 'admin' && isEditing
                  ? TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
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
              isEditing
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButton(
                          value: productCategory,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: productCategories.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newVal) {
                            setState(() {
                              productCategory = newVal!;
                            });
                          },
                        ),
                      ),
                    )
                  : Padding(
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
              child: user.type == 'admin' && isEditing
                  ? TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    )
                  : RichText(
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
              child: user.type == 'admin' && isEditing
                  ? TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    )
                  : Text(
                      _currentProduct.description,
                      style: const TextStyle(fontSize: 15),
                    ),
            ),
            if (user.type == 'admin')
              isEditing
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    )
                  : Padding(
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
            Container(color: Colors.black12, height: 5),
            if (user.type == 'admin')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: isEditing
                    ? Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Save',
                              onTap: saveProduct,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              onTap: cancelEdit,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : CustomButton(
                        text: 'Edit Product',
                        onTap: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                      ),
              )
            else
              _currentProduct.quantity == 0
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomButton(
                        text: 'Notify me when available',
                        onTap: () {},
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomButton(text: 'Buy Now', onTap: () {}),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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
