import 'package:apping/controller/Preferences.dart';
import 'package:apping/view/Calls_Page.dart';
import 'package:apping/view/Log_In_Page.dart';
import 'package:apping/view/Status_List_Page.dart';
import 'package:apping/view/User_List.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/allData.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: allData.bgAppColor,
            title:Text("Apping"),
            actions: [
              IconButton(onPressed: () {
                Preferences.setLoginNumber("");
                Get.to(LogInPage());
              }, icon: Icon(Icons.logout,color: Colors.white,))
            ],
            titleTextStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: allData.textWhiteColor
            ),
          ),
          body: TabBarView(
            children: [
              UserList(),
              StatusListPage(),
              CallsPage(),
            ],
          ),
          bottomNavigationBar: Container(
            color: allData.bgAppColor,
            child: TabBar(
              unselectedLabelColor: allData.hintTextGreyColor,
              indicatorColor: allData.iconWhiteColor,
              labelColor: allData.textWhiteColor,
              tabs: [
                Tab(text: "Chat",icon: Icon(Icons.chat),),
                Tab(text: "Status",icon: Icon(Icons.tips_and_updates_outlined),),
                Tab(text: "Calls",icon: Icon(Icons.call),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
