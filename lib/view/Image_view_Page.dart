import 'dart:convert';

import 'package:apping/model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../controller/allData.dart';

class ImageViewPage extends StatelessWidget {
  String image;
  ImageViewPage({required this.image,super.key});

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: allData.bgAppColor,
          title: Text("Image"),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25
          ),
          iconTheme: IconThemeData(
            color: Colors.white
          ),
        ),
        backgroundColor: allData.bgAppColor,
        body: Container(
            child: PhotoView(
              imageProvider: MemoryImage(
                base64Decode(image)
              ),
            )
        ),
      ),
    );
  }
}
