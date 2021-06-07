import 'dart:convert';

List<Forest> forestFromJson(String str) =>
    List<Forest>.from(json.decode(str).map((x) => Forest.fromJson(x)));

String forestToJson(List<Forest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forest {
  int id;
  String name;

  Forest({
    this.id,
    this.name,
  });

  factory Forest.fromJson(Map<String, dynamic> json) => Forest(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
