class UserModel {
  String id;
  String name;
  num number;
  String password;
  String image;
  String lastMessage;
  String lastTime;

  UserModel({
    required this.id,
    required this.name,
    required this.number,
    required this.password,
    required this.image,
    required this.lastMessage,
    required this.lastTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'password': password,
      'image': image,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      password: map['password'] ?? '',
      image: map['image'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastTime: map['lastTime'] ?? '',
    );
  }
}
