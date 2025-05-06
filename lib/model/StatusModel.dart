class StatusModel {
  final int number;
  final List<String> view;
  final String time;
  final String name;
  final String id;
  final List<String> imageList;

  StatusModel({
    required this.number,
    required this.view,
    required this.time,
    required this.name,
    required this.id,
    required this.imageList,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      number: json['number'],
      view: List<String>.from(json['view']),
      time: json['time'],
      name: json['name'],
      id: json['id'],
      imageList: List<String>.from(json['imageList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'view': view,
      'time': time,
      'name': name,
      'id': id,
      'imageList': imageList,
    };
  }
}