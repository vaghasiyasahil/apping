import 'dart:convert';

import 'package:apping/controller/Firebase_Services.dart';
import 'package:apping/controller/Preferences.dart';
import 'package:apping/model/UserModel.dart';
import 'package:apping/view/Chat_With_User_Page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';

import '../controller/allData.dart';
import 'Image_view_Page.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<UserModel> UserList=[];
  List<UserModel> searchUsers = [];
  TextEditingController searchCtr=TextEditingController();

  void filterSearch({required String query}) {
    List<UserModel> temp = [];
    if (query.isNotEmpty) {
      for (UserModel user in UserList) {
        if (user.name.toLowerCase().contains(query.toLowerCase()) || user.number.toString().contains(query)) {
          temp.add(user);
        }
      }
    } else {
      temp = UserList;
    }
    setState(() {
      searchUsers = temp;
    });
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: allData.bgAppColor,
        appBar: AppBar(
          backgroundColor: allData.bgAppColor,
          title: TextField(
            cursorColor: Colors.white,
            onChanged: (value) {
              filterSearch(query: searchCtr.text);
            },
            controller: searchCtr,
            style: TextStyle(color: allData.textWhiteColor),
            decoration: InputDecoration(
              hintText: "Search contacts...",
              hintStyle: TextStyle(color: allData.hintTextGreyColor),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: allData.hintTextGreyColor),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Firebase_Services.userRef.where('number',isNotEqualTo: int.parse(Preferences.getLoginNumber())).snapshots(),
                builder: (context,snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: Lottie.asset(width: 100,'assets/lottie/loaddata.json'),
                    );
                  }
                  if(snapshot.hasData){
                      UserList= snapshot.data!.docs.map((e) {
                        Map<String, dynamic> map = e.data() as Map<String, dynamic>;
                        return UserModel.fromMap(map);
                      }).toList();

                      if (searchCtr.text.isEmpty) {
                        searchUsers = List.from(UserList);
                      }

                    if(searchUsers.isNotEmpty){
                      return ListView.builder(
                        itemCount: searchUsers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.to(
                                  ChatWithUserPage(userModel: searchUsers[index],),
                                  transition: Transition.fadeIn,
                                  duration: Duration(seconds: 1)
                              );
                            },
                            contentPadding: EdgeInsets.all(10),
                            leading: InkWell(
                              onTap: () {
                                if(searchUsers[index].image!=""){
                                  Get.to(
                                      ImageViewPage(
                                          image: searchUsers[index].image
                                      ),
                                      transition: Transition.fade,
                                      duration: Duration(seconds: 2)
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 30,
                                child: searchUsers[index].image==""?Icon(Icons.person,color: allData.bgAppColor):null,
                                backgroundImage: searchUsers[index].image!=""?MemoryImage(
                                    base64Decode("${searchUsers[index].image}")
                                ):null,
                              ),
                            ),
                            title: Text("${searchUsers[index].name}",),
                            titleTextStyle: TextStyle(
                                color: allData.textWhiteColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                            subtitle: Text(searchUsers[index].lastMessage,maxLines: 1),
                            subtitleTextStyle: TextStyle(
                              color: allData.textWhiteColor,
                            ),
                            trailing: searchUsers[index].lastTime.split(" ")[0]==DateTime.now().toString().split(" ")[0]?
                              Text("${searchUsers[index].lastTime.split(" ")[1].split(":")[0]}:${searchUsers[index].lastTime.split(" ")[1].split(":")[1]} ${searchUsers[index].lastTime.split(" ")[2]}"):
                              Text("${searchUsers[index].lastTime.split(" ")[0].split("-")[2]}-${searchUsers[index].lastTime.split(" ")[0].split("-")[1]}-${searchUsers[index].lastTime.split(" ")[0].split("-")[0]}"),
                          );
                        },
                      );
                    }else{
                      return Center(
                        child: Text(
                          "No Contact Found",
                          style: TextStyle(
                            color: allData.hintTextGreyColor
                          ),
                        ),
                      );
                    }
                  }

                  return Center(
                    child: Text(
                      "Some thing went wrong.",
                      style: TextStyle(
                        color: allData.hintTextGreyColor
                      ),
                    ),
                  );

                },
              ),
            )
          ],
        ),
      ),
    );
  }





}
