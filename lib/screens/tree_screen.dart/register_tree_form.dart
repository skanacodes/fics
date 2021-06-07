import 'package:FIS/services/model.dart';
import 'package:FIS/services/models/treemodels.dart';
import 'package:flutter/cupertino.dart';

import 'package:FIS/services/constants.dart';
import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/size_config.dart';
import 'package:FIS/services/models/speciesmodels.dart';
import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NaturalForestForm extends StatefulWidget {
  final int id;
  NaturalForestForm(this.id);
  @override
  _NaturalForestFormState createState() => _NaturalForestFormState();
}

class _NaturalForestFormState extends State<NaturalForestForm> {
  final _formKey = GlobalKey<FormState>();
  int treeNo;
  int stemNo;
  String speciesName;
  double dbh;
  double heigth;
  double boleHeight;
  double stumpDiameter;
  String treeStatus;
  String steamstatus;
  bool isLoading = false;
  double stemHeight;
  List species = [];
  List treeList = [];
  int _counter = 1;
  int _incrementCounter() {
    setState(() {
      return _counter++;
    });
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

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments1 args = ModalRoute.of(context).settings.arguments;
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
                        child: Center(child: Text('Tree Number: $_counter')),
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
                          onPressed: () => _incrementCounter(),
                          icon: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildStemNoFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildSpeciesFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  children: [
                    Expanded(
                      child: buildbhFormField(),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Expanded(
                      child: buildheigthNoFormField(),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildboleHeightFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildStumpdiameterNoFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildStempHeightFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildTreeStatusFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Submit",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      print(treeList.length + 1);
                      print(stemNo);
                      print(speciesName);
                      print(dbh);
                      print(heigth);
                      print(boleHeight);
                      print(stumpDiameter);
                      print(treeStatus);

                      print(stemHeight);
                      print(args);
                      var result =
                          await DBProvider.db.insertSingleTree(TreeModel(
                        boleheight: boleHeight.toString(),
                        dbh: dbh.toString(),
                        height: heigth.toString(),
                        plotId: args.id,
                        isAlive: treeStatus,
                        stumpDiameter: stumpDiameter.toString(),
                        speciesId: int.parse(speciesName),
                        treeNo: _counter,
                        stumpHeight: stemHeight.toString(),
                        stemNo: stemNo,
                        uploadStatus: 'no',
                      ));
                      printResult(result);
                      //  print(species);
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
        desc: "Failed To Save Tree Details",
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

  TextFormField buildTreeNoFormField(int number) {
    return TextFormField(
      initialValue: number.toString(),

      enabled: false,
      keyboardType: TextInputType.number,
      onSaved: (number) => treeNo = int.parse(number),
      // onChanged: (val) {
      //   val = number.toString();
      //   setState(() {
      //     treeNo = int.parse(val);
      //   });
      // },
      decoration: InputDecoration(
        labelText: "Tree Number",
        hintText: "TreeNo",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == null ? 'Please fill in Tree Number' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildbhFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => dbh = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          dbh = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "DBH",
        hintText: "DBH",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? '* Required' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildboleHeightFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => boleHeight = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          boleHeight = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Bole Height",
        hintText: "Bole Height",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? '* Required' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildStumpdiameterNoFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => stumpDiameter = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          stumpDiameter = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Stump Diameter",
        hintText: "Stump Diameter",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? '* Required' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildheigthNoFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => heigth = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          heigth = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Height",
        hintText: "Height",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? '* Required' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildStempHeightFormField() {
    return TextFormField(
      onSaved: (newValue) => stemHeight = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          stemHeight = double.parse(value);
        });
      },
      cursorColor: kPrimaryColor,
      validator: (value) => value == '' ? 'Please fill in Stump Height' : null,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Stump Height",
        hintText: "Stump Height",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildStemNoFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      validator: (value) => value == '' ? '* Required' : null,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => stemNo = int.parse(newValue),
      onChanged: (value) {
        setState(() {
          stemNo = int.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Stem No",
        hintText: "Stem No",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  buildTreeStatusFormField() {
    return SafeArea(
      child: Container(
        child: Center(
          child: DropdownButtonFormField(
              value: treeStatus,
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: kPrimaryColor,
              ),
              hint: Text('Please Enter Tree Status'),
              itemHeight: 50,
              items: <String>['Live', 'Dead']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
              validator: (value) =>
                  value == null ? 'Please Enter Tree Status' : null,
              onChanged: (val) {
                setState(() {
                  treeStatus = val;
                });
              }),
        ),
      ),
    );
  }
}
