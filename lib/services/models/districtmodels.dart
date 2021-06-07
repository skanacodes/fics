import 'dart:convert';

List<Districts> forestFromJson(String str) =>
    List<Districts>.from(json.decode(str).map((x) => Districts.fromJson(x)));

String forestToJson(List<Districts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Districts {
  int id;
  String name;

  Districts({
    this.id,
    this.name,
  });

  factory Districts.fromJson(Map<String, dynamic> json) => Districts(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
