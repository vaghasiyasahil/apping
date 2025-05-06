class ChatModel {
  String msg;
  num receiver;
  num sender;
  String id;
  String type;
  String time;
  String status;

  ChatModel({
    required this.msg,
    required this.receiver,
    required this.sender,
    required this.id,
    required this.type,
    required this.time,
    required this.status
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      msg: json['msg'],
      receiver: json['receiver'],
      sender: json['sender'],
      id: json['id'],
      type: json['type'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'receiver': receiver,
      'sender': sender,
      'id': id,
      'type': type,
      'time':time,
      'status':status
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'receiver': receiver,
      'sender': sender,
      'id': id,
      'type': type,
      'time':time,
      'status':status,
    };
  }
}
