import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/districtmodels.dart';
import 'package:FIS/services/models/speciesmodels.dart';
import 'package:flutter/cupertino.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/size_config.dart';
import 'package:FIS/services/models/plotmodels.dart';
import 'package:flutter/material.dart';
import 'package:FIS/services/model.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PlotFormPlantation extends StatefulWidget {
  final int id;
  PlotFormPlantation(this.id);
  @override
  _PlotFormPlantationState createState() => _PlotFormPlantationState();
}

class _PlotFormPlantationState extends State<PlotFormPlantation> {
  final _formKey = GlobalKey<FormState>();
  String email;
  int plotSize;
  double slope;
  bool isTreeForm = false;
  bool isDeadWoodForm = false;
  String district;
  List plots = [];
  double radiusCorrection;
  String comments;
  int altitude;
  String forestName;
  double area = 0;
  int plotNo = 0;
  double easting = 0;
  double northings = 0;

  String date;
  Districts dist;
  String vegetationtype;
  String passwords;
  bool remember = false;
  bool isLoading = false;
  List forestnames = [];
  List districtnames = [];
  final List<String> errors = [];
  var finaldate;
  String plotDate;
  int _counter = 1;
  String crewLeader;
  String recorderName;
  String compartmentName;
  String compartmentArea;
  String speciesName;
  int plantedYear;
  String thiningStatus;

  int _incrementCounter(int number) {
    if (_counter < number) {
      setState(() {
        _counter++;
      });
    }
    return null;
  }

  int _decrementCounter() {
    if (_counter > 1) {
      setState(() {
        _counter--;
      });
      print(_counter);
    }
    return null;
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

  void callDatePicker() async {
    var order = await getDate();
    var formatter = new DateFormat('yyyy-MM-dd');
    setState(() {
      finaldate = formatter.format(order);
      print(finaldate);
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: kPrimaryColor,
          ),
          isMaterialAppTheme: true,
          child: child,
        );
      },
    );
  }

  // Define a function that inserts dogs into the database

  @override
  void initState() {
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: getProportionateScreenHeight(80),
                        width: getProportionateScreenWidth(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: kTextColor)),
                        child: Center(child: Text('plot#: $_counter')),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          onPressed: () => _decrementCounter(),
                          icon: Icon(
                            Icons.keyboard_arrow_left_rounded,
                            color: Colors.white,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          onPressed: () => _incrementCounter(args.plotNumber),
                          icon: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text('Of'),
                    ),
                    Expanded(
                      child: Container(
                        height: getProportionateScreenHeight(80),
                        width: getProportionateScreenWidth(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: kTextColor)),
                        child: Center(child: Text(args.plotNumber.toString())),
                      ),
                    )
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildDistrictFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildSpeciesFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildCompartmentAreaFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildCompartmentNameFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildRecorderNameFormField(),
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
                buildPlantedYearFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildCrewLeaderFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildThiningStatusFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildRadiusCorrectionFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildremarksFormField(),
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
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print(district);
                            print(compartmentArea);
                            print(compartmentName);
                            print(speciesName);
                            print(plantedYear);
                            print(thiningStatus);
                            print(crewLeader);
                            print(recorderName);
                            print(comments);

                            var result =
                                await DBProvider.db.insertSinglePlot(Plot(
                              altitude: altitude,
                              districtId: int.parse(district),
                              eastings: easting.toString(),
                              id: plotSize + 1000,
                              jobId: args.jobid,
                              northings: northings.toString(),
                              plotArea: area.toString(),
                              plotDate: finaldate,
                              plotNo: _counter.toString(),
                              plotsize: plotSize,
                              radiusCollection: radiusCorrection.toString(),
                              slope: slope.toString(),
                              vegetationType: vegetationtype,
                              comments: comments,
                              compartmentArea: compartmentArea,
                              compartmentName: compartmentName,
                              crewLeader: crewLeader,
                              plantedYear: plantedYear,
                              thiningStatus: thiningStatus,
                              speciesName: speciesName,
                              recorderName: recorderName,
                            ));

                            printResult(result);
                            _formKey.currentState.reset();
                            setState(() {
                              isLoading = false;
                            });
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

  void printResult(String result) {
    if (result == 'Success') {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Notification",
        desc: "You Have Succefull Submitted Your Plots Details",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: getProportionateScreenWidth(150),
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Notification",
        desc: "Failed To Save Plot Details",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: getProportionateScreenWidth(150),
          )
        ],
      ).show();
    }
  }

  buildSpeciesFormField() {
    return FutureBuilder<List<Species>>(
        future: DBProvider.db.getAllSpecies(),
        builder: (BuildContext context, AsyncSnapshot<List<Species>> snapshot) {
          // print(snapshot.data.length);
          if (!snapshot.hasData) return CircularProgressIndicator();
          return SafeArea(
            child: Container(
              child: Center(
                child: DropdownButtonFormField<String>(
                  value: speciesName,
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: kPrimaryColor,
                  ),
                  hint: Text('Select Species'),
                  itemHeight: 50,
                  isExpanded: true,
                  isDense: true,
                  items: snapshot.data
                      .map((dist) => DropdownMenuItem<String>(
                            child: Text(dist.name),
                            value: dist.id.toString(),
                          ))
                      .toList(),
                  onChanged: (String value) {
                    setState(() {
                      speciesName = value.toString();
                    });
                  },
                ),
              ),
            ),
          );
        });
  }

  buildDistrictFormField() {
    return FutureBuilder<List<Districts>>(
        future: DBProvider.db.getAllDistricts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Districts>> snapshot) {
          // print(snapshot.data.length);
          if (!snapshot.hasData) return CircularProgressIndicator();
          return SafeArea(
            child: Container(
              child: Center(
                child: DropdownButtonFormField<String>(
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: kPrimaryColor,
                  ),
                  hint: Text('Select Districts'),
                  itemHeight: 50,
                  isExpanded: true,
                  isDense: true,
                  items: snapshot.data
                      .map((forst) => DropdownMenuItem<String>(
                            child: Text(forst.name),
                            value: forst.id.toString(),
                          ))
                      .toList(),
                  onChanged: (String value) {
                    setState(() {
                      district = value;
                    });
                  },
                ),
              ),
            ),
          );
        });
  }

  TextFormField buildCompartmentAreaFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => compartmentArea = newValue,
      onChanged: (value) {
        setState(() {
          compartmentArea = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Compartment Area",
        hintText: "Enter Area",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) =>
          value == '' ? 'Please fill in Compartment Area' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildCompartmentNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => compartmentName = newValue,
      onChanged: (value) {
        setState(() {
          compartmentName = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Compartment Name",
        hintText: "Enter Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) =>
          value == '' ? 'Please fill in Compartment Name' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildThiningStatusFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => thiningStatus = newValue,
      onChanged: (value) {
        setState(() {
          thiningStatus = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Thining Status",
        hintText: "Enter Thining Status",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) =>
          value == '' ? 'Please fill in Thining Status' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildCrewLeaderFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => crewLeader = newValue,
      onChanged: (value) {
        setState(() {
          crewLeader = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Crew Leader",
        hintText: "Crew Leader",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) =>
          value == '' ? 'Please fill in Crew Leader Name' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildRecorderNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => recorderName = newValue,
      onChanged: (value) {
        setState(() {
          recorderName = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Recorder Name",
        hintText: "Recorder Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in recorder name' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildremarksFormField() {
    return TextFormField(
      maxLines: 6,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => comments = newValue,
      onChanged: (value) {
        setState(() {
          comments = value;
        });
      },
      decoration: InputDecoration(
        labelText: "General Comments",
        hintText: "Enter Comments",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in Comments' : null,
      cursorColor: kPrimaryColor,
    );
  }

  buildPlotFormField(int number) {
    return Container(
      child: TextFormField(
        initialValue: number.toString(),

        cursorColor: kPrimaryColor,
        //validator: (value) => value == null ? 'Please fill in Plot Number' : null,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            plotNo = int.parse(value);
          });
        },
        decoration: InputDecoration(
          labelText: "Plot No",
          hintText: "Plot",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  TextFormField buildSlopeFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      validator: (value) => value == '' ? 'Please fill in Plot Number' : null,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          slope = double.parse(value);
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
      cursorColor: kPrimaryColor,
      validator: (value) => value == '' ? 'Please fill in Plot Number' : null,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          plotSize = int.parse(value);
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
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      validator: (value) => value == '' ? 'fill Northings' : null,
      onSaved: (newValue) => northings = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          northings = double.parse(value);
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
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          easting = double.parse(value);
        });
      },
      validator: (value) => value == '' ? 'Fill Easting' : null,
      decoration: InputDecoration(
        labelText: "Eastings",
        hintText: "Eastings",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAltitudeFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => altitude = int.parse(newValue),
      onChanged: (value) {},
      validator: (value) => value == '' ? 'Please Fill In Altitude' : null,
      decoration: InputDecoration(
        labelText: "Altitude",
        hintText: "Enter Altitude",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  buildDateFormField() {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.green,
      ),
      child: SafeArea(
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
                        'Please Enter Date',
                      )
                    : Text(
                        finaldate.toString(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPlantedYearFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => plantedYear = int.parse(newValue),
      onChanged: (value) {},
      validator: (value) =>
          value == '' ? 'Please fill in Radius Correction' : null,
      decoration: InputDecoration(
        labelText: "Planted Year",
        hintText: "Enter Planted Year ",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRadiusCorrectionFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => radiusCorrection = double.parse(newValue),
      onChanged: (value) {},
      validator: (value) =>
          value == '' ? 'Please fill in Radius Correction' : null,
      decoration: InputDecoration(
        labelText: "Radius Correction",
        hintText: "Enter Radius Correction",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTypeFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => vegetationtype = newValue,
      onChanged: (value) {},
      validator: (value) =>
          value == '' ? 'Please Fill In Vegetation Type' : null,
      decoration: InputDecoration(
        labelText: "Vegetation Type",
        hintText: "Vegetation Type",
      ),
    );
  }
}
