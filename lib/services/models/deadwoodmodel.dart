import 'dart:convert';

List<DeadWoodModel> forestFromJson(String str) => List<DeadWoodModel>.from(
    json.decode(str).map((x) => DeadWoodModel.fromJson(x)));

String forestToJson(List<DeadWoodModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeadWoodModel {
  int id;
  int plotId;
  int deadWoodNo;
  String decay;
  String remarks;
  String length;
  String diameter1;
  String diameter2;
  int stemNo;
  int speciesId;

  DeadWoodModel(
      {this.id,
      this.deadWoodNo,
      this.plotId,
      this.speciesId,
      this.stemNo,
      this.decay,
      this.diameter1,
      this.diameter2,
      this.length,
      this.remarks});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plot_id': plotId,
      'species_id': speciesId,
      'diameter_one': diameter1,
      'diameter_two': diameter2,
      'length': length,
      'no_of_stems': stemNo,
      'decay': decay,
      'remarks': remarks,
      'deadWoodNo': deadWoodNo
    };
  }

  factory DeadWoodModel.fromJson(Map<String, dynamic> json) => DeadWoodModel(
      id: json["id"],
      speciesId: json["species_id"],
      plotId: json["plot_id"],
      diameter1: json["diameter_one"],
      diameter2: json["diameter_two"],
      decay: json["decay"],
      remarks: json["remarks"],
      stemNo: json["no_of_stems"],
      deadWoodNo: json["deadWoodNo"]);

  Map<String, dynamic> toJson() => {
        'id': id,
        'plot_id': plotId,
        'species_id': speciesId,
        'diameter_one': diameter1,
        'diameter_two': diameter2,
        'length': length,
        'no_of_stems': stemNo,
        'decay': decay,
        'remarks': remarks,
        'deadWoodNo': deadWoodNo
      };
}
