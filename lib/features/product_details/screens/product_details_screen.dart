import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
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
  const ProductDetailsScreen({super.key,required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final productDetailsServices = ProductDetailsServices();
  double averageRating=0;
  double myRating=0;


  @override
  void initState() {
    super.initState();
    double totalRating=0;
    for(int i=0;i<widget.product.ratings!.length;i++){
      totalRating+=widget.product.ratings![i].rating;
      if(widget.product.ratings![i].userId==Provider.of<UserProvider>(context,listen: false).user.id){
        myRating = widget.product.ratings![i].rating;
      }
    }
    if(totalRating!=0){
      averageRating=totalRating/widget.product.ratings!.length;
    }
  }


  void navigateToSearchScreen(String query){
    Navigator.pushNamed(context, SearchScreen.routeName,arguments: query);
  }

  void addToCart() {
    productDetailsServices.addToCart(
      context: context, 
      product: widget.product
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55), 
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(  //purpose of this for giving elevation to child
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: (){},
                          child:const Padding(
                            padding:EdgeInsets.only(left : 6.0),
                            child: Icon(Icons.search,color: Colors.black,size: 23,),
                          ),
                        ),
                        hintText: 'Search Amazon.in',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17 
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top:10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(color: Colors.black38, width:1),
                        ),
                      ),
                    ),
                  )
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25
                ),
              )
            ],
          ),
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
                  Text(
                    widget.product.id!
                  ),
                  Stars(rating: averageRating)
                ],
              ),
            ),
            //title of product
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                widget.product.name,
                style:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            //product images
            CarouselSlider(
              items: widget.product.imageUrls.map((i)  {
                return Builder(
                  builder: (BuildContext context) =>Image.network(
                    i,
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                );
              }).toList(), 
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300
              )
            ),
            const SizedBox(height: 10,),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            //product price
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text : 'Deal Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  children: [
                    TextSpan(
                      text : '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w400
                      ),
                    )
                  ]
                ),
              ),
            ),
            //product description
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.product.description,
                style:const TextStyle(
                  fontSize: 15
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: 'Buy Now', 
                onTap: (){}
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: CustomButton(
                text: 'Add To Cart', 
                onTap: addToCart,
                color: const Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal:8),
              child: Text(
                'Rate The Product',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            RatingBar.builder(
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemBuilder: (context, _)=> const Icon(
                Icons.star,
                color: GlobalVariables.secondaryColor,
              ), 
              onRatingUpdate: (rating){
                productDetailsServices.rateProduct(
                  context: context, 
                  product: widget.product, 
                  rating: rating,
                  onSuccess: (){}   //for realtime showing the changes of average rating of product
                );
              }
            )
          ],
        ),
      ),
    );
  }
}