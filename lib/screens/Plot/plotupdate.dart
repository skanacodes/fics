import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/size_config.dart';

import 'package:intl/intl.dart';

class PlotUpdate extends StatefulWidget {
  final String plotnumber;
  final int jobid;
  final int plotId;
  final String plotarea;
  final int numberOfPlots;
  final int disrictId;
  final int forestId;
  final String eastings;
  final String northings;
  final int plotsize;
  final String slop;
  final String radiuscollection;
  final int altitude;
  final String measurer;
  final String vegtype;
  final String finaldate;

  PlotUpdate(
      {this.plotnumber,
      this.finaldate,
      this.disrictId,
      this.forestId,
      this.jobid,
      this.numberOfPlots,
      this.altitude,
      this.eastings,
      this.measurer,
      this.northings,
      this.plotId,
      this.plotarea,
      this.plotsize,
      this.radiuscollection,
      this.slop,
      this.vegtype});
  @override
  _PlotUpdateState createState() => _PlotUpdateState();
}

class _PlotUpdateState extends State<PlotUpdate> {
  final _formKey = GlobalKey<FormState>();
  String email;
  int plotSize;
  String slope;
  bool isTreeForm = false;
  bool isDeadWoodForm = false;
  String district;
  String radiusCorrection;
  int altitude;
  String forestName;
  String area;
  String plotNo;
  String easting;
  String northings;

  String measurer;
  String date;
  String vegetationtype;
  String passwords;
  bool remember = false;
  bool isLoading = false;
  List forestnames = [];
  List districtnames = [];
  final List<String> errors = [];
  var finaldate;
  String plotDate;

  _updatePlots(int jobId, int plotId, BuildContext context) async {
    // set up PUT request arguments
    String url =
        'https://mis.tfs.go.tz/fremis-test/api/v1/plots/update/$plotId';
    Map<String, String> headers = {"Content-type": "application/json"};
    Map data = {
      'job_id': jobId,
      'plot_no': 1,
      'plot_area': area,
      'eastings': easting,
      'northings': northings,
      'plot_size': plotSize,
      'district_id': district,
      'slope': slope,
      'radius_correction': radiusCorrection,
      'altitude': altitude,
      'measurer': measurer,
      'vegetation_type': vegetationtype,
      'inventory_date': finaldate,
      'forest_id': forestName,
    };
    // make PUT request
    http.Response response =
        await http.put(url, headers: headers, body: jsonEncode(data));
    print(response.reasonPhrase);
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    // this API passes back the updated item with the id added
    //print(body);
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 1
    // }
  }

  formatDate(var date) {
    var now = date;
    var formatter = new DateFormat('yyyy-MM-dd');
    setState(() {
      String plotDate = formatter.format(now);
      print(plotDate);
    });
    return plotDate;
  }

  fetchforest() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://mis.tfs.go.tz/fremis-test/api/v1/get-forest";
    var response = await http.get(url);
    // print(response.body);
    print(response.statusCode);
    var res = json.decode(response.body);
    // print(res);
    //  print(res['msg']);

    if (response.statusCode == 200) {
      // print(res);
      var items = res['data'];
      print(items);

      // print(items);
      setState(() {
        forestnames = items;
        isLoading = false;
      });
    } else {
      forestnames = [];
      isLoading = false;
    }
  }

  fetchDistrict() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://mis.tfs.go.tz/fremis-test/api/v1/get-districts";
    var response = await http.get(url);
    // print(response.body);
    print(response.statusCode);
    var res = json.decode(response.body);
    // print(res);
    //  print(res['msg']);

    if (response.statusCode == 200) {
      // print(res);
      var items = res['data'];
      // String spec = res['data'][0]['name'].toString();
      // print(spec);
      print(items);

      // print(items);
      setState(() {
        districtnames = items;

        isLoading = false;
      });
    } else {
      districtnames = [];
      isLoading = false;
    }
  }

  void callDatePicker() async {
    var order = await getDate();
    var formatter = new DateFormat('yyyy-MM-dd');
    setState(() {
      finaldate = formatter.format(order) ?? widget.finaldate;
      print(finaldate);
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          // isMaterialAppTheme: true,
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    this.fetchDistrict();
    this.fetchforest();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          SizedBox(height: getProportionateScreenHeight(20)),
          Container(
            height: getProportionateScreenHeight(60),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(
                  getProportionateScreenHeight(20),
                ),
                border: Border.all(color: Colors.black38)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description,
                  color: Colors.white,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Text(
                  'Update Plot Details',
                  style: TextStyle(
                      fontSize: getProportionateScreenHeight(20),
                      color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                buildDistrictFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildForestFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildAreaFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  children: [
                    Expanded(child: buildPlotFormField()),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Text('Of'),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Expanded(
                        child: Container(
                      height: getProportionateScreenHeight(80),
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kTextColor)),
                      child:
                          Center(child: Text(widget.numberOfPlots.toString())),
                    )),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  children: [
                    Expanded(child: buildNorthingFormField()),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Expanded(child: buildEastingFormField()),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildPlotsizeFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildSlopeFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildAltitudeFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildRadiusCorrectionFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildMeasurerFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildTypeFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildDateFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                isLoading
                    ? CupertinoActivityIndicator(
                        animating: true,
                        radius: getProportionateScreenHeight(30),
                      )
                    : DefaultButton(
                        text: "Submit",
                        press: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print(altitude);
                            print(area);
                            print(district);
                            print(easting);
                            print(measurer);
                            print(forestName);
                            print(northings);
                            print(vegetationtype);
                            print(radiusCorrection);
                            print(finaldate);
                            print(slope);
                            print(plotSize);
                            print(widget.plotId);
                            print(widget.jobid);
                            int id = widget.plotId;
                            _updatePlots(widget.jobid, widget.plotId, context);
                            // print(args.jobid);
                            //updatePlotData(widget.plotId, context);
                            // Navigator.pushNamed(context, RegisterTree.routeName);
                          }
                        },
                      ),
                SizedBox(height: getProportionateScreenHeight(60)),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildDistrictFormField() {
    return SafeArea(
      child: Container(
        child: Center(
          child: DropdownButtonFormField(
              value: district,
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: kPrimaryColor,
              ),
              hint: Text('Please Select District'),
              itemHeight: 50,
              isExpanded: true,
              isDense: true,
              items: districtnames.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString() ?? widget.disrictId,
                    );
                  })?.toList() ??
                  [],
              validator: (value) =>
                  value == null ? 'Please fill in district' : null,
              onChanged: (val) {
                setState(() {
                  district = val;
                });
              }),
        ),
      ),
    );
  }

  buildForestFormField() {
    return SafeArea(
      child: Container(
        child: Center(
          child: DropdownButtonFormField(
              value: forestName,
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: kPrimaryColor,
              ),
              hint: Text('Select Forest'),
              itemHeight: 50,
              isExpanded: true,
              isDense: true,
              items: forestnames.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  })?.toList() ??
                  [],
              validator: (value) =>
                  value == null ? 'Please fill in forest' : null,
              onChanged: (val) {
                setState(() {
                  forestName = val;
                });
              }),
        ),
      ),
    );
  }

  TextFormField buildAreaFormField() {
    return TextFormField(
      initialValue: widget.plotarea.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) => area = newValue ?? widget.plotarea,
      onChanged: (value) {
        setState(() {
          area = value ?? widget.plotarea;
        });
      },
      decoration: InputDecoration(
        labelText: "Area(ha)",
        hintText: "Enter Area",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == null ? 'Please fill in Area in ha' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildPlotFormField() {
    return TextFormField(
      initialValue: widget.plotnumber.toString(),
      cursorColor: kPrimaryColor,
      validator: (value) => value == null ? 'Please fill in Plot Number' : null,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          plotNo = value ?? widget.plotnumber;
        });
      },
      decoration: InputDecoration(
        labelText: "Plot No",
        hintText: "Plot",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildSlopeFormField() {
    return TextFormField(
      initialValue: widget.slop.toString(),
      cursorColor: kPrimaryColor,
      validator: (value) => value == null ? 'Please fill in Plot Number' : null,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => slope = newValue ?? widget.slop,
      onChanged: (value) {
        setState(() {
          slope = value ?? widget.slop;
        });
      },
      decoration: InputDecoration(
        labelText: "Slope",
        hintText: "Enter Slope",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPlotsizeFormField() {
    return TextFormField(
      initialValue: widget.plotsize.toString(),
      cursorColor: kPrimaryColor,
      validator: (value) => value == null ? 'Please fill in Plot Number' : null,
      onSaved: (newValue) => plotSize = int.parse(newValue) ?? widget.plotsize,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          plotSize = int.parse(value) ?? widget.plotsize;
        });
      },
      decoration: InputDecoration(
        labelText: "Plot Size",
        hintText: "Enter Plot Size",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNorthingFormField() {
    return TextFormField(
      initialValue: widget.northings.toString(),
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      validator: (value) => value == null ? 'Please fill in Northings' : null,
      onSaved: (newValue) => northings = newValue ?? widget.northings,
      onChanged: (value) {
        setState(() {
          northings = value ?? widget.northings;
        });
      },
      // ignore: missing_return

      decoration: InputDecoration(
        labelText: "Northings",
        hintText: "Northing",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEastingFormField() {
    return TextFormField(
      initialValue: widget.eastings.toString(),
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => easting = newValue ?? widget.eastings,
      onChanged: (value) {
        setState(() {
          easting = value ?? widget.eastings;
        });
      },
      validator: (value) => value == null ? 'Please fill in Easting' : null,
      decoration: InputDecoration(
        labelText: "Eastings",
        hintText: "Eastings",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAltitudeFormField() {
    return TextFormField(
      initialValue: widget.altitude.toString(),
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => altitude = newValue ?? widget.altitude,
      onChanged: (value) {},
      validator: (value) => value == null ? 'Please Fill In Altitude' : null,
      decoration: InputDecoration(
        labelText: "Altitude",
        hintText: "Enter Altitude",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  buildDateFormField() {
    return SafeArea(
      child: InkWell(
        onTap: () => callDatePicker,
        child: Container(
          width: 300,
          decoration: BoxDecoration(
              border: Border.all(
                style: BorderStyle.solid,
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: <Widget>[
              new IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: callDatePicker,
                color: kPrimaryColor,
              ),
              finaldate == null
                  ? Text(
                      widget.finaldate,
                    )
                  : Text(
                      finaldate.toString(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildMeasurerFormField() {
    return TextFormField(
      initialValue: widget.measurer,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => measurer = newValue ?? widget.measurer,
      onChanged: (value) {},
      validator: (value) => value == null ? 'Please fill in Measurer' : null,
      decoration: InputDecoration(
        labelText: "Measurer",
        hintText: "Enter Measurer",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRadiusCorrectionFormField() {
    return TextFormField(
      initialValue: widget.radiuscollection.toString(),
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) =>
          radiusCorrection = newValue ?? widget.radiuscollection,
      onChanged: (value) {},
      validator: (value) =>
          value == null ? 'Please fill in Radius Correction' : null,
      decoration: InputDecoration(
        labelText: "Radius Correction",
        hintText: "Enter Radius Correction",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTypeFormField() {
    return TextFormField(
      initialValue: widget.vegtype.toString(),
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => vegetationtype = newValue ?? widget.vegtype,
      onChanged: (value) {},
      validator: (value) =>
          value == null ? 'Please Fill In Vegetation Type' : null,
      decoration: InputDecoration(
        labelText: "Vegetation Type",
        hintText: "Vegetation Type",
      ),
    );
  }
}
