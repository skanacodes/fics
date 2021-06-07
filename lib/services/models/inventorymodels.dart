import 'dart:convert';

List<Inventory> forestFromJson(String str) =>
    List<Inventory>.from(json.decode(str).map((x) => Inventory.fromJson(x)));

String forestToJson(List<Inventory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Inventory {
  int jobId;
  String name;
  int forestId;
  String inventoryPurpose;
  String title;
  String samplingMethod;
  int numberOfPlots;
  String startDate;
  String endDate;
  String createdAt;
  String updatedAt;
  String supervisor;
  String deletedAt;
  String jobtype;
  Inventory(
      {this.jobId,
      this.jobtype,
      this.name,
      this.forestId,
      this.inventoryPurpose,
      this.supervisor,
      this.title,
      this.samplingMethod,
      this.numberOfPlots,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
      jobId: json["id"],
      forestId: json["forest_id"],
      name: json["name"],
      inventoryPurpose: json["inventory_purpose"],
      supervisor: json["supervisor"],
      title: json["title"],
      samplingMethod: json["sampling_method"],
      numberOfPlots: json["number_of_plots"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      jobtype: json["job_type"]);

  Map<String, dynamic> toJson() => {
        "id": jobId,
        "forest_id": forestId,
        "name": name,
        "inventory_purpose": inventoryPurpose,
        "supervisor": supervisor,
        "title": title,
        "sampling_method": samplingMethod,
        "number_of_plots": numberOfPlots,
        "start_date": startDate,
        "end_date": endDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "job_type": jobtype
      };
}
