import 'package:FIS/services/constants.dart';
import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:FIS/services/models/speciesmodels.dart';
import 'package:FIS/services/Providers/db_Provider.dart';

class TreeUpdate extends StatefulWidget {
  final int id;
  final int treeno;
  final int stemno;
  final double dbh;
  final double height;
  final double boleHeight;
  final double stumpHeight;
  final double stumpdiameter;
  final int plotId;
  final int speciesId;
  final String isalive;
  const TreeUpdate(
      {this.id,
      this.treeno,
      this.stemno,
      this.dbh,
      this.height,
      this.boleHeight,
      this.stumpHeight,
      this.stumpdiameter,
      this.isalive,
      this.plotId,
      this.speciesId});
  @override
  _TreeUpdateState createState() => _TreeUpdateState();
}

class _TreeUpdateState extends State<TreeUpdate> {
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

  @override
  Widget build(BuildContext context) {
    int args = ModalRoute.of(context).settings.arguments;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
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
                  'Enter Tree Details',
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
                Row(
                  children: [
                    Expanded(
                      child: buildTreeNoFormField(),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Expanded(
                      child: buildStemNoFormField(),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                  ],
                ),
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
                Row(
                  children: [
                    Expanded(
                      child: buildboleHeightFormField(),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Expanded(
                      child: buildStumpdiameterNoFormField(),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildStempHeightFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildTreeStatusFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Submit",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      print(treeNo);
                      print(stemNo);
                      print(speciesName);
                      print(dbh);
                      print(heigth);
                      print(boleHeight);
                      print(stumpDiameter);
                      print(treeStatus);

                      print(stemHeight);
                      print(args);

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

  TextFormField buildTreeNoFormField() {
    return TextFormField(
      initialValue: widget.treeno.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) => treeNo = int.parse(newValue),
      onChanged: (value) {
        setState(() {
          treeNo = int.parse(value) ?? widget.treeno;
        });
      },
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
      initialValue: widget.treeno.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) => dbh = double.parse(newValue) ?? widget.dbh,
      onChanged: (value) {
        setState(() {
          dbh = double.parse(value) ?? widget.dbh;
        });
      },
      decoration: InputDecoration(
        labelText: "DBH",
        hintText: "DBH",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == null ? 'Please fill in Area DBH' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildboleHeightFormField() {
    return TextFormField(
      initialValue: widget.boleHeight.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) =>
          boleHeight = double.parse(newValue) ?? widget.boleHeight,
      onChanged: (value) {
        setState(() {
          boleHeight = double.parse(value) ?? widget.boleHeight;
        });
      },
      decoration: InputDecoration(
        labelText: "Bole Height",
        hintText: "Bole Height",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == null ? 'Please fill in Bohe height' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildStumpdiameterNoFormField() {
    return TextFormField(
      initialValue: widget.stumpdiameter.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) =>
          stumpDiameter = double.parse(newValue) ?? widget.stumpdiameter,
      onChanged: (value) {
        setState(() {
          stumpDiameter = double.parse(value) ?? widget.stumpdiameter;
        });
      },
      decoration: InputDecoration(
        labelText: "Stump Diameter",
        hintText: "",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) =>
          value == null ? 'Please fill in Stump Diameter' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildheigthNoFormField() {
    return TextFormField(
      initialValue: widget.height.toString(),
      keyboardType: TextInputType.number,
      onSaved: (newValue) => heigth = double.parse(newValue) ?? widget.height,
      onChanged: (value) {
        setState(() {
          heigth = double.parse(value) ?? widget.height;
        });
      },
      decoration: InputDecoration(
        labelText: "Height",
        hintText: "Height",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == null ? 'Please fill in Heigth' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildStempHeightFormField() {
    return TextFormField(
      initialValue: widget.stumpHeight.toString(),
      onSaved: (newValue) =>
          stemHeight = double.parse(newValue) ?? widget.stumpHeight.toString(),
      onChanged: (value) {
        setState(() {
          stemHeight = double.parse(value) ?? widget.stumpHeight.toString();
        });
      },
      cursorColor: kPrimaryColor,
      validator: (value) =>
          value == null ? 'Please fill in Stump Height' : null,
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
      initialValue: widget.stemno.toString(),
      // ignore: deprecated_member_use
      autovalidate: true,
      cursorColor: kPrimaryColor,
      validator: (value) => value == null ? 'Please fill in Stem Number' : null,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => stemNo = int.parse(newValue) ?? widget.stemno,
      onChanged: (value) {
        setState(() {
          stemNo = int.parse(value) ?? widget.stemno;
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
