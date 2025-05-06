import 'dart:convert';

import 'package:apping/controller/Firebase_Services.dart';
import 'package:apping/controller/Preferences.dart';
import 'package:apping/controller/Select_Media.dart';
import 'package:apping/controller/allData.dart';
import 'package:apping/model/StatusModel.dart';
import 'package:apping/model/UserModel.dart';
import 'package:apping/view/Status_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class StatusListPage extends StatelessWidget {
  const StatusListPage({super.key});

  @override
  Widget build(BuildContext context) {

    ValueNotifier<Select_Multi_Media> select_status_media=ValueNotifier(Select_Multi_Media([]));

    return Scaffold(
      backgroundColor: allData.bgAppColor,
      body: Column(
        children: [
          StreamBuilder(
            stream: Firebase_Services.statusRef.where("number",isEqualTo: int.parse(Preferences.getLoginNumber()),).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                StatusModel status=StatusModel.fromJson(snapshot.data!.docs[0].data() as Map<String,dynamic>);
                return ListTile(
                  onTap: () {
                    Get.to(
                        StatusView(
                            statusModel: status
                        ),
                        transition: Transition.cupertinoDialog,
                        duration: Duration(seconds: 1)
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: MemoryImage(
                      base64Decode(status.imageList.last)
                    ),
                  ),
                  title: Text(
                    status.name,
                    style: TextStyle(
                      color: allData.textWhiteColor
                    ),
                  ),
                  subtitle: Text(
                    status.time,
                    style: TextStyle(
                      color: allData.hintTextGreyColor
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () async {
                              await Firebase_Services.deleteStatus(id: status.id);
                            },
                            child: Text("Delete"),
                          ),
                        )
                      ];
                    },
                  ),
                );
              }
              return Container();
            },
          ),
          
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Updates",
                style: TextStyle(
                  color: allData.hintTextGreyColor
                ),
              )
            ),
          ),
          
          Expanded(
            child: StreamBuilder(
              stream: Firebase_Services.statusRef.where('number',isNotEqualTo: int.parse(Preferences.getLoginNumber())).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List tempData=snapshot.data!.docs;
                  List<StatusModel> StatusData=tempData.map((e) => StatusModel.fromJson(e.data()),).toList();
                  if(StatusData.isNotEmpty){
                    return ListView.builder(
                      itemCount: StatusData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Get.to(
                              StatusView(
                                statusModel: StatusData[index]
                              ),
                              transition: Transition.cupertinoDialog,
                              duration: Duration(seconds: 1)
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: MemoryImage(
                              base64Decode(StatusData[index].imageList.last)
                            ),
                          ),
                          title: Text(
                            StatusData[index].name,
                            style: TextStyle(
                                color: allData.textWhiteColor
                            ),
                          ),
                          subtitle: Text(
                            StatusData[index].time,
                            style: TextStyle(
                              color: allData.hintTextGreyColor
                            ),
                          ),

                        );
                      },
                    );
                  }else{
                    return Center(
                      child: Text(
                        "No Status Found",
                        style: TextStyle(
                            color: allData.hintTextGreyColor
                        ),
                      ),
                    );
                  }
                }
                return Center(
                  child: Lottie.asset(width: 100,'assets/lottie/loaddata.json'),
                );
              },
            )
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await select_status_media.value.pickStatusImage();
          await Firebase_Services.addStatus(image: select_status_media.value.value);
          await select_status_media..value.value=[];
        },
        backgroundColor: allData.hintTextGreyColor,
        child: Icon(
          Icons.add,
          color: allData.textWhiteColor,
        ),
      ),
    );
  }
}
