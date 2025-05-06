import 'dart:convert';

import 'package:apping/controller/Firebase_Services.dart';
import 'package:apping/controller/Preferences.dart';
import 'package:apping/controller/Select_Media.dart';
import 'package:apping/controller/allData.dart';
import 'package:apping/model/ChatModel.dart';
import 'package:apping/model/UserModel.dart';
import 'package:apping/view/Image_view_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWithUserPage extends StatelessWidget {
  UserModel userModel;
  ChatWithUserPage({required this.userModel,super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController msg=TextEditingController();
    ScrollController scrollController = ScrollController();
    ValueNotifier<Select_Media> select_media=ValueNotifier(Select_Media(""));

    return Scaffold(

      backgroundColor: allData.bgAppColor,

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: allData.iconWhiteColor
        ),
        title: Text("${userModel.name}"),
        titleTextStyle: TextStyle(
          color: allData.textWhiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        actions: [
          IconButton(onPressed: () async {
            try{
              await launchUrl(Uri.parse('tel:${userModel.number}'));
            }catch(e){
              Get.snackbar("Error", "Something Went Wrong!!",colorText: Colors.red);
            }
          }, icon: Icon(Icons.call)),
          IconButton(onPressed: () async {
            try{
              await launchUrl(Uri.parse('https://wa.me/${userModel.number}'));
            }catch(e){
              Get.snackbar("Error", "Something Went Wrong!!",colorText: Colors.red);
            }
          }, icon: Icon(Icons.video_call)),
        ],
        backgroundColor: allData.bgAppColor,
      ),


      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: Firebase_Services.getStreamChat(userNumber: userModel.number),
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasData){
                    List<ChatModel> chatList=snapshot.data!.docs.map<ChatModel>((e) {
                      Map<String, dynamic> map=e.data() as Map<String,dynamic>;
                      return ChatModel.fromJson(map);
                    }).toList();
                    // chatList.sort((a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));

                    if(chatList.isNotEmpty){
                      chatList.sort((a, b) => DateFormat("yyyy-MM-dd hh:mm:ss a").parse(a.time).compareTo(DateFormat("yyyy-MM-dd hh:mm:ss a").parse(b.time)));

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(scrollController.position.maxScrollExtent);
                        }
                      });


                      return ListView.builder(
                        controller: scrollController,
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          if(chatList[index].receiver==int.parse(Preferences.getLoginNumber())){
                            Firebase_Services.updateSeenStatus(id: chatList[index].id);
                          }
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: chatList[index].receiver==userModel.number ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: chatList[index].type=='text'?10:5, horizontal: chatList[index].type=='text'?14:5),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: chatList[index].receiver==userModel.number ? allData.senderTextMessageBgColor : allData.receiverTextMessageBgColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: chatList[index].receiver==userModel.number ? Radius.circular(15) : Radius.zero,
                                    bottomRight: chatList[index].receiver==userModel.number ? Radius.zero : Radius.circular(15),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: chatList[index].receiver==userModel.number?CrossAxisAlignment.end:CrossAxisAlignment.start,
                                  children: [
                                    chatList[index].type=='text'?Text(
                                      "${chatList[index].msg}",
                                      style: TextStyle(
                                        color: chatList[index].receiver==userModel.number ? allData.senderMessageBgColor : allData.receiverMessageBgColor,
                                        fontSize: 16,
                                      ),
                                    ):InkWell(
                                      onTap: () {
                                        Get.to(
                                            ImageViewPage(
                                                image: chatList[index].msg
                                            ),
                                            transition: Transition.fade,
                                            duration: Duration(seconds: 2)
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: chatList[index].receiver==userModel.number ? Radius.circular(15) : Radius.zero,
                                          bottomRight: chatList[index].receiver==userModel.number ? Radius.zero : Radius.circular(15),
                                        ),
                                        child: Image.memory(
                                          base64Decode(chatList[index].msg),
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Text(
                                            "${chatList[index].time.split(" ")[1]} ${chatList[index].time.split(" ")[2]}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        if (chatList[index].receiver==userModel.number) ...[
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.done_all,
                                            size: 16,
                                            color: chatList[index].status=='Seen' ? Colors.blue : Colors.white70,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      return Center(
                        child: Text(
                          "Chat With ${userModel.name}",
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: msg,
              cursorColor: allData.iconWhiteColor,
              style: TextStyle(
                  fontSize: 25,
                  color: allData.textWhiteColor
              ),
              decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                      color: allData.hintTextGreyColor
                  ),
                  fillColor: allData.textFiledBgColor,
                  filled: true,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () async {
                        await select_media.value.pickImage();
                        if (select_media.value.value!="") {
                          Get.dialog(
                            AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            contentPadding: EdgeInsets.all(0),
                            content: Image.memory(
                              base64Decode(select_media.value.value),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actionsPadding: EdgeInsets.zero,
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  select_media.value.value="";
                                  Get.back();
                                }, child: Text(
                                  "No,Send",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.red
                                  ),
                                )
                              ),
                              OutlinedButton(
                                  onPressed: () {
                                    msg.text="";
                                    if(Firebase_Services.addMessage(msg: select_media.value.value, type: "image",receiver: userModel.number)) {
                                      select_media.value.value="";
                                      Get.back();
                                    }
                                  }, child: Text(
                                "Yes,Send",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.green
                                ),
                              )
                              ),
                            ],
                          ),);
                        }
                      }, icon: Icon(Icons.image)),
                      IconButton(onPressed: () {
                        if(msg.text!=""){
                          if(Firebase_Services.addMessage(msg: msg.text, type: "text",receiver: userModel.number)) {
                            Firebase_Services.setLastMessage(number: userModel.number, msg: msg.text);
                            Firebase_Services.setLastMessage(number: int.parse(Preferences.getLoginNumber()), msg: msg.text);
                            msg.text="";
                          }
                        }else if(select_media.value.value!=""){
                          if(Firebase_Services.addMessage(msg: select_media.value.value, type: "image",receiver: userModel.number)) {
                            select_media.value.value="";
                            Firebase_Services.setLastMessage(number: userModel.number, msg: "Image");
                            Firebase_Services.setLastMessage(number: int.parse(Preferences.getLoginNumber()), msg: "Image");
                          }
                        }
                      }, icon: Icon(Icons.send)),
                    ],
                  ),
                  suffixIconColor: allData.iconWhiteColor,
                  prefixIconColor: allData.textWhiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20)
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: allData.bgAppColor
                    )
                  )
              ),
            ),
          )
        ],
      ),


      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: TextField(
      //     controller: msg,
      //     cursorColor: allData.iconWhiteColor,
      //     style: TextStyle(
      //         fontSize: 25,
      //         color: allData.textWhiteColor
      //     ),
      //     decoration: InputDecoration(
      //         hintText: "Type a message...",
      //         hintStyle: TextStyle(
      //             color: allData.hintTextGreyColor
      //         ),
      //         fillColor: allData.textFiledBgColor,
      //         filled: true,
      //         suffixIcon: IconButton(onPressed: () {
      //           Firebase_Services.addMessage(msg: msg.text, type: "text",receiver: userModel.number);
      //         }, icon: Icon(Icons.send)),
      //         suffixIconColor: allData.iconWhiteColor,
      //         prefixIconColor: allData.textWhiteColor,
      //         border: OutlineInputBorder(
      //           borderRadius: BorderRadius.all(
      //               Radius.circular(20)
      //           ),
      //         ),
      //         focusedBorder: OutlineInputBorder(
      //             borderSide: BorderSide(
      //                 color: allData.bgAppColor
      //             )
      //         )
      //     ),
      //   ),
      // ),
    );
  }
}
