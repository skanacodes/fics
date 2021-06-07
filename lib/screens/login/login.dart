import 'package:FIS/screens/login/login_body.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: getProportionateScreenHeight(350),
                child: Stack(
                  children: [
                    Container(
                      height: getProportionateScreenHeight(400),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(150),
                            bottomRight: Radius.circular(150),
                          )),
                    ),
                    Positioned(
                      top: 130,
                      left: 100,
                      right: 100,
                      child: Container(
                        height: getProportionateScreenHeight(180),
                        width: getProportionateScreenWidth(60),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                              )
                            ]),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fitWidth,
                          height: getProportionateScreenHeight(100),
                        ),
                      ),
                    ),
                  ],
                )),
            Body()
          ],
        ),
      ),
    );
  }
}
