import 'dart:convert';

import 'package:apping/controller/Firebase_Services.dart';
import 'package:apping/controller/Select_Media.dart';
import 'package:apping/controller/allData.dart';
import 'package:apping/view/Home_Page.dart';
import 'package:apping/view/Log_In_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController name=TextEditingController();
    TextEditingController number=TextEditingController();
    TextEditingController password=TextEditingController();
    ValueNotifier<Select_Media> select_media=ValueNotifier(Select_Media(""));
    return Scaffold(
      backgroundColor: allData.bgAppColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: allData.bgAppColor,
        title: Text("Register", style: TextStyle(color: allData.textWhiteColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  select_media.value.pickImage();
                },
                child: ValueListenableBuilder(valueListenable: select_media.value, builder: (context, value, child) {
                  return CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: value != "" ? MemoryImage(base64Decode(value)) : null,
                    child: value == ""
                        ? Icon(Icons.camera_alt, color: allData.iconWhiteColor, size: 40)
                        : null,
                  );
                },),
              ),
              SizedBox(height: 20),
              TextField(
                controller: name,
                cursorColor: allData.tealColor,
                style: TextStyle(color: allData.textWhiteColor),
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(color: allData.hintTextGreyColor),
                  prefixIcon: Icon(Icons.person, color: allData.iconWhiteColor),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: allData.tealColor),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: number,
                cursorColor: allData.tealColor,
                style: TextStyle(color: allData.textWhiteColor),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  hintStyle: TextStyle(color: allData.hintTextGreyColor),
                  prefixIcon: Icon(Icons.phone,color: allData.textWhiteColor),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: allData.tealColor),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: password,
                cursorColor: allData.tealColor,
                style: TextStyle(color: allData.textWhiteColor),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: allData.hintTextGreyColor),
                  prefixIcon: Icon(Icons.lock, color: allData.textWhiteColor),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: allData.tealColor),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Alread Account??",
                    style: TextStyle(
                        color: allData.hintTextGreyColor,
                        fontSize: 20
                    ),
                  ),
                  TextButton(onPressed: () {
                    Get.to(LogInPage(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
                  }, child: Text(
                    "Log In",
                    style: TextStyle(
                        color: allData.textWhiteColor,
                        fontSize: 20
                    ),
                  )
                  )
                ],
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  await Firebase_Services.addUser(name: name.text, number: int.parse(number.text), password: password.text, image: select_media.value.value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: allData.textFiledBgColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text("Register", style: TextStyle(fontSize: 18,color: allData.textWhiteColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

