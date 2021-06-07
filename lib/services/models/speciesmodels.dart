import 'dart:convert';

List<Species> forestFromJson(String str) =>
    List<Species>.from(json.decode(str).map((x) => Species.fromJson(x)));

String forestToJson(List<Species> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Species {
  int id;
  String name;

  Species({
    this.id,
    this.name,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        id: json["id"],
        name: json["scientific_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scientific_name": name,
      };
}
