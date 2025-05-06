import 'package:apping/controller/Firebase_Services.dart';
import 'package:apping/view/Register_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/allData.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {


    TextEditingController number=TextEditingController();
    TextEditingController password=TextEditingController();
    return Scaffold(
      backgroundColor: allData.bgAppColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: allData.bgAppColor,
        title: Text("Log In", style: TextStyle(color: allData.textWhiteColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    "Create Account??",
                    style: TextStyle(
                      color: allData.hintTextGreyColor,
                      fontSize: 20
                    ),
                  ),
                  TextButton(onPressed: () {
                    Get.to(RegisterPage(),transition: Transition.rightToLeft,duration: Duration(seconds: 1));
                  }, child: Text(
                      "Register",
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
                  await Firebase_Services.loginUser(number: number.text, password: password.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: allData.textFiledBgColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text("Log In", style: TextStyle(fontSize: 18,color: allData.textWhiteColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
