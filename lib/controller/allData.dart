import 'dart:ui';
import 'package:apping/view/No_Internet_Page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class allData{

  //app color
  static Color bgAppColor=Color.fromARGB(255, 12, 20, 27);
  static Color textWhiteColor=Colors.white;
  static Color iconWhiteColor=Colors.white;
  static Color textFiledBgColor=Color.fromARGB(255, 31, 39, 42);
  static Color receiverTextMessageBgColor=Color.fromARGB(255, 35, 38, 38);
  // static Color receiverTextMessageBgColor=Color.fromARGB(255, 31, 39, 42);
  static Color senderTextMessageBgColor=Color.fromARGB(255, 20, 77, 55);
  // static Color senderTextMessageBgColor=Color.fromARGB(255, 19, 77, 55);
  static Color senderMessageBgColor=Colors.white;
  static Color receiverMessageBgColor=Colors.white;
  static Color hintTextGreyColor=Colors.grey;
  static Color tealColor=Colors.teal;

  static Future<bool> checkInternetConnection() async {
    print("check Coneection");
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.to(NoInternetPage());
      return false; // No connection at all (WiFi/Mobile)
    }else{
      return true;
    }
  }

}