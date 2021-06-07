import 'dart:async';

import 'package:FIS/screens/Inventory/inventory_list_screen.dart';
import 'package:FIS/screens/login/login.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      SharedPreferences.getInstance().then((prefs) {
        print(prefs.get('id').toString());
        if (prefs.get('id').toString() != 'null') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InventoryListScreen()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome To Forest Inventory System',
            style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: getProportionateScreenWidth(20)),
          ),
          Container(
            height: getProportionateScreenHeight(150),
            width: getProportionateScreenHeight(150),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          SpinKitDoubleBounce(
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
