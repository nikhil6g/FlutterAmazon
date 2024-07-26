import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final int maxLines;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword=false,
    this.maxLines= 1,
  });
  
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border:const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          )
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
      validator: (val){
        if(val==null|| val.isEmpty){
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}