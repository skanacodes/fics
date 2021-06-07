import 'dart:convert';

List<TreeModel> forestFromJson(String str) =>
    List<TreeModel>.from(json.decode(str).map((x) => TreeModel.fromJson(x)));

String forestToJson(List<TreeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TreeModel {
  int id;
  int plotId;
  int treeNo;
  int stemNo;
  int speciesId;
  String height;
  String dbh;
  String boleheight;
  String stumpDiameter;
  String stumpHeight;
  String treeForm;
  String remarks;
  String sampeTree;
  String hdom;
  String isAlive;
  String uploadStatus;

  TreeModel(
      {this.id,
      this.boleheight,
      this.dbh,
      this.height,
      this.isAlive,
      this.plotId,
      this.speciesId,
      this.stemNo,
      this.uploadStatus,
      this.stumpDiameter,
      this.stumpHeight,
      this.treeNo,
      this.hdom,
      this.remarks,
      this.sampeTree,
      this.treeForm});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tree_no': treeNo,
      'stem_no': stemNo,
      'plot_id': plotId,
      'species_id': speciesId,
      'dbh': dbh,
      'height': height,
      'bole_height': boleheight,
      'stump_diameter': stumpDiameter,
      'stump_height': stumpHeight,
      'is_alive': isAlive,
      'comments': remarks,
      'tree_form': treeForm,
      'uploadStatus': uploadStatus
    };
  }

  factory TreeModel.fromJson(Map<String, dynamic> json) => TreeModel(
      id: json["id"],
      treeNo: json["tree_no"],
      plotId: json["plot_id"],
      speciesId: json["species_id"],
      dbh: json["dbh"],
      height: json["height"],
      stemNo: json["stem_no"],
      boleheight: json["bole_height"],
      stumpDiameter: json["stump_diameter"],
      stumpHeight: json["stump_height"],
      isAlive: json["is_alive"],
      remarks: json["comments"],
      treeForm: json["treeForm"],
      uploadStatus: json["uploadStatus"]);

  Map<String, dynamic> toJson() => {
        'id': id,
        'tree_no': treeNo,
        'stem_no': stemNo,
        'plot_id': plotId,
        'species_id': speciesId,
        'dbh': dbh,
        'height': height,
        'bole_height': boleheight,
        'stump_diameter': stumpDiameter,
        'stump_height': stumpHeight,
        'is_alive': isAlive,
        'comments': remarks,
        'tree_form': treeForm,
        'uploadStatus': uploadStatus
      };
}
