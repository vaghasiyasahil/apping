import 'package:apping/controller/Preferences.dart';
import 'package:apping/model/ChatModel.dart';
import 'package:apping/model/StatusModel.dart';
import 'package:apping/model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../view/Home_Page.dart';

class Firebase_Services{
  static CollectionReference userRef=FirebaseFirestore.instance.collection('user');
  static CollectionReference chatRef=FirebaseFirestore.instance.collection('chat');
  static CollectionReference statusRef=FirebaseFirestore.instance.collection('status');

  static Stream getStreamUser() {
    return Firebase_Services.userRef.snapshots();
  }

  static Stream getStreamChat({required num userNumber}){
    return Firebase_Services.chatRef
        .where('sender',whereIn: [int.parse(Preferences.getLoginNumber()),userNumber])
        .where('receiver', whereIn: [int.parse(Preferences.getLoginNumber()),userNumber])
        .snapshots();
  }

  static Future<bool> addUser({required String name,required num number,required String password,required String image}) async {
    try{
      await userRef.where('number',isEqualTo: number).get().then((value) async {
        if(value.docs.isEmpty){
          UserModel userModel=UserModel(id: "", name: name, number: number, password: password, image: image,lastMessage: "Start Chat",lastTime: DateTime.now().toString());
          await userRef.add(userModel.toMap()).then((value) async {
            value.update({
              "id":value.id
            });
            await Preferences.setLoginNumber(number.toString());
            await Preferences.setLoginName(name);
          },);
          Get.to(HomePage(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
        }else{
          Get.snackbar("Error", "Number Alread Exit",colorText: Colors.red);
          return false;
        }
      },);
    }catch(e){
      return false;
    }
    return false;
  }

  static Future<bool> loginUser({required String number,required String password}) async {
    try{
      await userRef.where('number',isEqualTo: int.parse(number)).where('password',isEqualTo: password).get().then((value) async {
        if(value.docs.isNotEmpty){
          await Preferences.setLoginNumber(number);
          Map data=value.docs[0].data() as Map<String,dynamic>;
          await Preferences.setLoginName(data['name']);
          Get.to(HomePage(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
        }else{
          Get.snackbar("Error", "Wrong Number and Password",colorText: Colors.red);
        }
      },);
    }catch(e){
      return false;
    }
    return false;
  }

  static bool addMessage({required String msg,required String type,required num receiver}){
    try{
      String time=DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now()).toString();
      ChatModel chatModel=ChatModel(msg: msg, receiver: receiver, sender: int.parse(Preferences.getLoginNumber()), id: "", type: type,time: time,status: 'notSeen');
      chatRef.add(chatModel.toMap()).then((value) {
        value.update({
          "id":value.id
        });
      },);
    }catch(e){
      return false;
    }
    return true;
  }

  static bool addStatus({required List<String> image}){
    try{
      String time=DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now()).toString();
      StatusModel statusModel=StatusModel(
        number: int.parse(Preferences.getLoginNumber()),
        view: [],
        time: time,
        id: "",
        name: Preferences.getLoginName(),
        imageList: image
      );
      statusRef.add(statusModel.toJson()).then((value) {
        value.update({
          'id':value.id.toString()
        });
      },);
    }catch(e){
      return false;
    }
    return true;
  }

  static Future<bool> deleteStatus({required String id}) async {
    try{
      await statusRef.doc(id).delete();
      return true;
    }catch(e){
      return false;
    }
  }

  static Future<bool> updateSeenStatus({required String id}) async {
    try{
      await Firebase_Services.chatRef.doc(id).update({
        'status':'Seen'
      });
      print("Update Seen Status");
      return true;
    }catch(e){
      return false;
    }
  }

  static bool setLastMessage({required num number,required String msg}){
    try{
      String time=DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now()).toString();
      Firebase_Services.userRef.where('number',isEqualTo: number).get().then((value) {
        UserModel userModel=UserModel.fromMap(value.docs[0].data() as Map<String,dynamic>);
        Firebase_Services.userRef.doc(userModel.id).update({
          'lastMessage':msg,
          'lastTime':time
        });
      },);
      return true;
    }catch(e){
      return false;
    }
  }

}