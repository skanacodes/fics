import 'dart:convert';

import 'package:FIS/services/models/treemodels.dart';

List<Plot> forestFromJson(String str) =>
    List<Plot>.from(json.decode(str).map((x) => Plot.fromJson(x)));

String forestToJson(List<Plot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plot {
  int id;
  int jobId;
  String plotNo;
  String plotArea;
  String eastings;
  String northings;
  int plotsize;
  String slope;
  String radiusCollection;
  int altitude;
  String measurer;
  String vegetationType;
  String plotDate;
  int districtId;

  String crewLeader;
  String recorderName;
  String compartmentName;
  String compartmentArea;
  String speciesName;
  int plantedYear;
  String thiningStatus;

  String comments;
  List<TreeModel> treeList;

  Plot({
    this.id,
    this.jobId,
    this.plotArea,
    this.altitude,
    this.eastings,
    this.measurer,
    this.northings,
    this.plotDate,
    this.plotNo,
    this.plotsize,
    this.radiusCollection,
    this.slope,
    this.vegetationType,
    this.districtId,
    this.comments,
    this.compartmentArea,
    this.compartmentName,
    this.crewLeader,
    this.plantedYear,
    this.recorderName,
    this.speciesName,
    this.thiningStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp_id': id,
      'job_id': jobId,
      'plot_no': plotNo,
      'eastings': eastings,
      'northings': northings,
      'plot_size': plotsize,
      'slope': slope,
      'radius_correction': radiusCollection,
      'altitude': altitude,
      'measurer': measurer,
      'vegetation_type': vegetationType,
      'inventory_date': plotDate,
      'district_id': districtId,
      'plot_area': plotArea,
      'species_name': speciesName,
      'crew_leader': crewLeader,
      'recorder_name': recorderName,
      'compartment_name': compartmentName,
      'compartment_area': compartmentArea,
      'planted_year': plantedYear,
      'thinning_status': thiningStatus,
      'comments': comments
    };
  }

  factory Plot.fromJson(
    Map<String, dynamic> json,
  ) {
    return Plot(
      id: int.parse(json["temp_id"]),
      jobId: int.parse(json["job_id"]),
      plotNo: json["plot_no"],
      eastings: json["eastings"],
      northings: json["northings"],
      plotsize: int.parse(json["plot_size"]),
      slope: json["slope"],
      radiusCollection: json["radius_correction"],
      altitude: int.parse(json["altitude"]),
      measurer: json["measurer"],
      vegetationType: json["vegetation_type"],
      plotDate: json["inventory_date"],
      districtId: int.parse(json["district_id"]),
      plotArea: json["plot_area"],
      comments: json["comments"],
      compartmentArea: json["compartment_area"],
      compartmentName: json["compartment_name"],
      crewLeader: json["crew_leader"],
      plantedYear: json["planted_year"],
      recorderName: json["recorder_name"],
      speciesName: json["species_name"],
      thiningStatus: json["thinning_status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "temp_id": id.toString(),
      "job_id": jobId.toString(),
      "plot_area": plotArea,
      "plot_no": plotNo,
      "eastings": eastings,
      "northings": northings,
      "plot_size": plotsize,
      "slope": slope,
      "radius_correction": radiusCollection,
      "altitude": altitude.toString(),
      "measurer": measurer,
      "vegetation_type": vegetationType,
      "inventory_date": plotDate,
      "district_id": districtId.toString(),
      "species_name": speciesName,
      "crew_leader": crewLeader,
      "recorder_name": recorderName,
      "compartment_name": compartmentName,
      "compartment_area": compartmentArea,
      "planted_year": plantedYear.toString(),
      "thinning_status": thiningStatus,
      "comments": comments,
    };
  }
}
