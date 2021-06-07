import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:FIS/screens/Inventory/inventory_list_screen.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/custom_surfix_icon.dart';
import 'package:FIS/services/default_button.dart';
import 'package:FIS/services/form_error.dart';
import 'package:FIS/services/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String passwords;
  bool remember = false;
  final List<String> errors = [];
  bool isLoading = false;
  bool showError = false;

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {});
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  bool _isHidden = true;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildPasswordFormField('Password'),
          showError ? getErrorMessage(context) : Container(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          isLoading
              ? getLoadin(context)
              : DefaultButton(
                  text: "Continue",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        isLoading = true;
                      });

                      _getCurrentLocation();
                      await signIn(email, passwords, context);
                    }
                  },
                ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField(String password) {
    return TextFormField(
      obscureText: password == "Password" ? _isHidden : false,
      onSaved: (newValue) => passwords = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: password == "Password"
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(
                        Icons.visibility_off,
                        color: kTextColor,
                      )
                    : Icon(
                        Icons.visibility,
                        color: kTextColor,
                      ),
              )
            : null,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  getErrorMessage(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: getProportionateScreenWidth(14),
          width: getProportionateScreenWidth(14),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Text('Invalid Username or Password'),
      ],
    );
  }

  getLoadin(BuildContext context) {
    return CupertinoActivityIndicator(
      animating: true,
      radius: 20,
    );
  }

  signIn(String email, String password, BuildContext context) async {
    getLoadin(context);
    String url =
        "https://mis.tfs.go.tz/fremis-test/api/v1/login?username=$email&password=$password";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    final response = await http.get(url, headers: headers);

    var res = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
    if (res['msg'] == 'User Details') {
      saveUserData(
          res['user']['id'],
          res['user']['first_name'],
          res['user']['last_name'],
          res['user']['email'],
          res['user']['user_roles'][1]['role_name']);
      var x = await insertUserData(
          res['user']['id'],
          res['user']['first_name'],
          res['user']['last_name'],
          res['user']['email'],
          res['user']['user_roles'][1]['role_name'],
          passwords);
      if (x == 'Success') {
        Navigator.pushNamed(context, InventoryListScreen.routeName);
      } else {
        print(x);
      }
    } else {
      print(response.body.toString());
      setState(() {
        showError = true;
      });
      getErrorMessage(
        context,
      );
    }
  }

  saveUserData(id, firstname, secondname, email, role) {
    print(id);
    print(firstname);
    print(secondname);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('id', id.toString());
      prefs.setString('firstname', firstname);
      prefs.setString('secondname', secondname);
      prefs.setString('email', email);
      prefs.setString('roles', role);
    });
  }

  insertUserData<String>(id, firstname, secondname, email, role, password) {
    print(id);
    return DBProvider.db.insertUser(User(
      id: id,
      fname: firstname,
      lname: secondname,
      email: email,
      password: password,
      roles: role,
      statusfetch: 0,
    ));
  }
}
