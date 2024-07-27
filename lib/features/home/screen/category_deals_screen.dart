import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key,required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  final _homeServices = HomeServices(); 
  List<Product>? productList;

  @override
  void initState() {
    super.initState();
    fetchCategoryProduct();
  }

  void fetchCategoryProduct() async {
    productList = await _homeServices.fetchCategoryProduct(
      context: context, 
      category: widget.category
    );
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return productList == null ?
    const Loader()
    :
    Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), 
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black
            ),
          )
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical:10),
            alignment: Alignment.topLeft,
            child: Text(
              'Keep shopping for ${widget.category}',
              style:const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 15),
              itemCount: productList!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.4,
                mainAxisSpacing: 10
              ), 
              itemBuilder: (context,index){
                Product productData = productList![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailsScreen.routeName ,arguments: productData);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(productData.imageUrls[0]),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 0, top: 5, right: 15),
                        child: Text(
                          productData.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
          )
        ],
      )
    );
  }
}