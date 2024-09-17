import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName='/address';
  final String totalAmount;
  const AddressScreen({super.key,required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController flatBuildingController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String addressToBeUsed = "";

  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  final _addressFormKey = GlobalKey<FormState>();

  List<PaymentItem> _paymentItems = [];

  final AddressServices addressServices = AddressServices();

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('gpay.json');
    _paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amout',
        status: PaymentItemStatus.final_price
      )
    );
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
    if(Provider.of<UserProvider>(context,listen: false).user.address.isEmpty){
      addressServices.saveUserAddress(context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context, 
      address: addressToBeUsed, 
      totalAmount: double.parse(widget.totalAmount)
    );
  }
  
  void payPressed(String addressFromProvider){
    addressToBeUsed = "";
    bool isForm = flatBuildingController.text.isNotEmpty 
      || areaController.text.isNotEmpty
      || cityController.text.isNotEmpty 
      || pincodeController.text.isNotEmpty;
    if(isForm){
      if(_addressFormKey.currentState!.validate()){
        addressToBeUsed = '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      }else{
        throw Exception('Please enter all the values!');
      }
    }else if(addressFromProvider.isNotEmpty){
      addressToBeUsed = addressFromProvider;
    }else{
      showSnackBar(context, 'ERROR');
    }
    debugPrint(addressToBeUsed);
  }

  @override
  Widget build(BuildContext context) {
    var address =context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55), 
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text(
                      'OR', 
                      style: TextStyle(
                        fontSize: 19
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House No, Building',
                    ),
                    const SizedBox(height: 15,),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, street',
                    ),
                    const SizedBox(height: 15,),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 15,),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 15,),
                  ],
                )
              ),
              FutureBuilder<PaymentConfiguration>(
              future: _googlePayConfigFuture,
              builder: (context, snapshot) => snapshot.hasData
                  ? GooglePayButton(
                      onPressed: () => payPressed(address),
                      width: double.infinity,
                      height: 50,
                      theme: GooglePayButtonTheme.dark,
                      paymentConfiguration: snapshot.data!,
                      paymentItems: _paymentItems,
                      type: GooglePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink()
                ),
            ],
          ),
        ),
      ),
    );
  }
}