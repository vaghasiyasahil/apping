import 'dart:convert';

import 'package:apping/model/StatusModel.dart';
import 'package:flutter/material.dart';
import 'package:story/story.dart';

import '../controller/allData.dart';

class StatusView extends StatelessWidget {
  final StatusModel statusModel;

  StatusView({required this.statusModel, super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: allData.bgAppColor,
        title: Text(statusModel.name),
        titleTextStyle: TextStyle(
          color: allData.textWhiteColor,
          fontSize: 25
        ),
        iconTheme: IconThemeData(
          color: allData.textWhiteColor
        ),
      ),
      backgroundColor: allData.bgAppColor,
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          return Container(
            color: allData.bgAppColor,
            child: Center(
              child: Image.memory(
                  base64Decode(statusModel.imageList[storyIndex])
              ),
            ),
          );
        },
        storyLength: (pageIndex) => statusModel.imageList.length,
        pageLength: 1,
      ),
    );
  }
}
