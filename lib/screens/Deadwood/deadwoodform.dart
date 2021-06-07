import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/models/deadwoodmodel.dart';
import 'package:FIS/services/models/speciesmodels.dart';
import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeadWoodForm extends StatefulWidget {
  @override
  _DeadWoodFormState createState() => _DeadWoodFormState();
}

class _DeadWoodFormState extends State<DeadWoodForm> {
  final _formKey = GlobalKey<FormState>();
  int treeNo;
  int stemNo;
  String speciesName;
  double diamter1;
  double diameter2;
  double length;
  int deadWoodNo;

  String decay;
  String remarks;
  bool isLoading = false;

  List species = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments1 args = ModalRoute.of(context).settings.arguments;
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
                      child: buildDeadwoodNoFormField(),
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
                builddiameter1FormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                builddiameter2FormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildlengthFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Center(
                    child: Text(
                  'Plot Radius 15m Minimum Diameter 10cm',
                  style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                )),
                SizedBox(height: getProportionateScreenHeight(20)),
                builddecayFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                buildremarksFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Submit",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      print(deadWoodNo);
                      print(stemNo);

                      print(speciesName);
                      print(diamter1);
                      print(diameter2);
                      print(length);
                      print(decay);
                      print(remarks);
                      final res = await DBProvider.db.insertSingleDeadWood(
                          DeadWoodModel(
                              deadWoodNo: deadWoodNo,
                              stemNo: stemNo,
                              decay: decay,
                              diameter1: diamter1.toString(),
                              diameter2: diameter2.toString(),
                              plotId: args.id,
                              remarks: remarks,
                              speciesId: int.parse(speciesName),
                              length: length.toString()));
                      printResult(res);
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
        desc: "You Have Succefull Submitted Your DeadWood Details",
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
        desc: "Failed To Save DeadWood Details",
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

  TextFormField builddiameter1FormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => diamter1 = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          diamter1 = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Diameter 1",
        hintText: "Enter Diameter 1(cm)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in Diameter One' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField builddiameter2FormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => diameter2 = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          diameter2 = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Diameter 2",
        hintText: "Enter Diameter 2(cm)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in Diameter Two' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildDeadwoodNoFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => deadWoodNo = int.parse(newValue),
      onChanged: (value) {
        setState(() {
          deadWoodNo = int.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Number",
        hintText: "DeadWood Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == ' ' ? '* Requiered' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildlengthFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => length = double.parse(newValue),
      onChanged: (value) {
        setState(() {
          length = double.parse(value);
        });
      },
      decoration: InputDecoration(
        labelText: "Length",
        hintText: "Enter Length(0.5)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in Length' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField builddecayFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => decay = newValue,
      onChanged: (value) {
        setState(() {
          decay = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Decay",
        hintText: "Enter Decay(S/R)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => value == '' ? 'Please fill in Decay' : null,
      cursorColor: kPrimaryColor,
    );
  }

  TextFormField buildStemNoFormField() {
    return TextFormField(
      cursorColor: kPrimaryColor,
      validator: (value) => value == '' ? '* Requiered' : null,
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
}
