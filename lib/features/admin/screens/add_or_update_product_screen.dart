import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddOrUpdateProductScreen extends StatefulWidget {
  static const String routeName = '/add-or-update-product';
  final Product? product;
  const AddOrUpdateProductScreen({super.key, this.product});

  @override
  State<AddOrUpdateProductScreen> createState() =>
      _AddOrUpdateProductScreenState();
}

class _AddOrUpdateProductScreenState extends State<AddOrUpdateProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController soldCountController = TextEditingController();

  final AdminServices adminServices = AdminServices();

  final _addProductFormKey = GlobalKey<FormState>();

  String defaultCategory = 'Mobiles';

  List<File> images = [];

  late Product _currentProduct;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _currentProduct = widget.product!;
      productNameController.text = _currentProduct.name;
      descriptionController.text = _currentProduct.description;
      priceController.text = _currentProduct.price.toString();
      quantityController.text = _currentProduct.quantity.toString();
      brandController.text = _currentProduct.brand;
      tagsController.text = _currentProduct.tags;
      soldCountController.text = _currentProduct.soldCount.toString();

      defaultCategory = _currentProduct.category;
    }
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    tagsController.dispose();
    brandController.dispose();
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        brand: brandController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: defaultCategory,
        images: images,
        tags: tagsController.text,
        onSuccess: () {
          showSnackBar(context, 'Product added successfully');
          Navigator.pop(context); // to remove add_product_screen
          Navigator.pushReplacementNamed(
            context,
            AdminScreen
                .routeName, //to remove old adminscreen and push new adminscreen
          );
        },
      );
    }
  }

  void saveProduct() {
    double newPrice =
        double.tryParse(priceController.text) ?? _currentProduct.price;
    double newQuantity =
        double.tryParse(quantityController.text) ?? _currentProduct.quantity;
    Product updatedProduct = Product(
      name: productNameController.text,
      description: descriptionController.text,
      brand: brandController.text,
      price: newPrice,
      quantity: newQuantity,
      imageUrls: _currentProduct.imageUrls,
      category: defaultCategory,
      id: _currentProduct.id,
      tags: tagsController.text,
      soldCount: double.parse(soldCountController.text),
      ratings: _currentProduct.ratings,
    );
    adminServices.updateProductDetails(
      context: context,
      updatedProduct: updatedProduct,
      onSuccess: () {
        _currentProduct = updatedProduct;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.pop(context);
      },
    );
  }

  void cancelEdit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          centerTitle: true,
          title: Text(
            widget.product != null ? 'Update Product' : 'Add Product',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                widget.product != null
                    ? CarouselSlider(
                        items: _currentProduct.imageUrls.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.network(
                              i,
                              fit: BoxFit.contain,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options:
                            CarouselOptions(viewportFraction: 1, height: 300),
                      )
                    : images.isNotEmpty
                        ? CarouselSlider(
                            items: images.map((i) {
                              return Builder(
                                builder: (BuildContext context) => Image.file(
                                  i,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                                viewportFraction: 1, height: 200),
                          )
                        : GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select Product Images',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'description',
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: brandController,
                  hintText: 'brand',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: tagsController,
                  hintText: 'Product Tags',
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: defaultCategory,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        defaultCategory = newVal!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.product != null
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
                    : CustomButton(text: 'Sell', onTap: sellProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
