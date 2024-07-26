import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try{
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      lockParentWindow: true,
    );
    if(files!=null && files.files.isNotEmpty){
      for(int i=0;i<files.files.length;i++){
        images.add(File(files.files[i].path!));
      }
    }
    for(int j=0;j<images.length;j++){
      debugPrint(images[j].toString());
    }
  }catch(e){
    debugPrint(e.toString());
  }
  return images;
}
