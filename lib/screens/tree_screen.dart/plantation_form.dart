import 'dart:convert';
import 'package:FIS/services/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PlantationForm extends StatefulWidget {
  final int id;
  PlantationForm(this.id);
  @override
  _PlantationFormState createState() => _PlantationFormState();
}

class _PlantationFormState extends State<PlantationForm> {
  final _formKey = GlobalKey<FormState>();
  int treeNo;
  String treeForm;
  String sampleTree;
  int stemNo;
  String remarks;
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
  double hdom;

  _incrementCounter() {
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

  postTreeData(int plotId, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    print(plotId);
    Map data = {
      'tree_no': treeList.length + 1,
      'stem_no': stemNo,
      'plot_id': plotId,
      'species_id': speciesName,
      'dbh': dbh,
      'height': heigth,
      'bole_height': boleHeight,
      'stump_diameter': stumpDiameter,
      'stump_height': stemHeight,
      'is_alive': treeStatus,
    };
    const url = 'https://mis.tfs.go.tz/fremis-test/api/v1/tree/create';
    String body = json.encode(data);

    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var re = response.reasonPhrase;
    var status = response.statusCode;
    //var res = json.decode(response.body);
    print(re);
    // print(res['msg']);

    print(status);
    // print(res['msg']);
    if (status == 201) {
      setState(() {
        isLoading = false;
      });
      return Alert(
        context: context,
        type: AlertType.success,
        title: "Notification",
        desc: "You Have Succefull Submitted Your Tree Details",
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
      setState(() {
        isLoading = false;
      });

      return Alert(
        context: context,
        type: AlertType.error,
        title: "Notification",
        desc: "Tree Details Cannot be Saved",
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
                buildbhFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: Card(
                    elevation: 5,
                    shadowColor: kPrimaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              'Heigth(m)',
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontSize: getProportionateScreenHeight(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          buildSampleTreeFormField(),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          buildHdomFormField(),
                          SizedBox(height: getProportionateScreenHeight(20)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildTreeFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildremarksFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Submit",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      // print(treeList.length + 1);
                      // print(stemNo);
                      // print(speciesName);
                      // print(dbh);
                      // print(heigth);
                      // print(boleHeight);
                      print(remarks);
                      // print(treeStatus);
                      print(hdom);
                      print(treeForm);
                      print(remarks); // print(stemHeight);
                      // print(args);

                      // postTreeData(args.id, context);
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

  TextFormField buildremarksFormField() {
    return TextFormField(
      maxLines: 6,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => remarks = newValue,
      onChanged: (value) {
        setState(() {
          remarks = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Remarks",
        hintText: "Enter Remarks",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in Remarks' : null,
      cursorColor: kPrimaryColor,
    );
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

  TextFormField buildHdomFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => hdom = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          hdom = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Hdom",
        hintText: "Hdom",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? '* Required' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildSampleTreeFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => sampleTree = newValue,
      onChanged: (value) {
        setState(() {
          sampleTree = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Sample Tree",
        hintText: "Sample Tree",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? '* Required' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildTreeFormField() {
    return TextFormField(
      onSaved: (newValue) => treeForm = newValue,
      onChanged: (value) {
        setState(() {
          treeForm = value;
        });
      },
      cursorColor: kPrimaryColor,
      validator: (value) => value == '' ? 'Please fill in Tree Form ' : null,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Tree Form",
        hintText: "Tree Form",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
