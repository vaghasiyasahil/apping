import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Select_Media extends ValueNotifier<String>{
  Select_Media(super.value);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      value=base64Encode(await image.readAsBytes());
    }else{
      value="";
    }
    notifyListeners();
  }
}

class Select_Multi_Media extends ValueNotifier<List<String>>{
  Select_Multi_Media(super.value);

  Future<void> pickStatusImage()async{
    final picker=ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if(images.isNotEmpty){
      for(int i=0;i<images.length;i++){
        value.add(base64Encode(await images[i].readAsBytes()));
      }
    }
  }

}