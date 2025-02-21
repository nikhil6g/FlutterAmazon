import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/widget/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final adminServices = AdminServices();
  List<Product>? productList;

  void navigateToPrdouctDetailsPage(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts(
        context); //as initState can't be declared as async so we create a new function is added
  }

  fetchAllProducts(BuildContext context) async {
    productList = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          productList!.removeAt(index);
          setState(() {});
        });
  }

  void navigateToVoidAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return productList == null
        ? const Loader()
        : Scaffold(
            body: productList!.isEmpty
                ? const Center(
                    child: Text(
                      'No product to sell..\n Please add some',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )
                : GridView.builder(
                    itemCount: productList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      Product productData = productList![index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () => {
                            navigateToPrdouctDetailsPage(context, productData)
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 122,
                                child: SingleProduct(
                                  image: productData.imageUrls[0],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        productData.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    //delete button
                                    IconButton(
                                      onPressed: () {
                                        deleteProduct(productData, index);
                                      },
                                      icon: const Icon(Icons.delete_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add a product',
              backgroundColor: const Color.fromARGB(255, 29, 201, 192),
              onPressed: navigateToVoidAddProduct,
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
