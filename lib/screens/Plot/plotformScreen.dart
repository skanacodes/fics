import 'package:FIS/screens/Plot/plot_form.dart';
import 'package:FIS/screens/Plot/plot_form_plantation.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/cupertino.dart';

import 'package:FIS/services/constants.dart';
import 'package:flutter/material.dart';

class PlotFormScreen extends StatefulWidget {
  static String routeName = "/plotform";

  @override
  _PlotFormScreenState createState() => _PlotFormScreenState();
}

class _PlotFormScreenState extends State<PlotFormScreen> {
  int jobid;
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    setState(() {
      jobid = args.jobid;
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, jobid),
        ),
        title: Text(
          'Enter Plots Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(120),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              getProportionateScreenHeight(100)),
                          bottomRight: Radius.circular(
                              getProportionateScreenHeight(100)))),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: CircleAvatar(
                      radius: getProportionateScreenHeight(100),
                      backgroundColor: kPrimaryColor,
                      child: CircleAvatar(
                        radius: 76,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/plot.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: args.jobtype == 'plantation'
                  ? PlotFormPlantation(args.jobid)
                  : PlotForm(args.jobid),
            ),
          ],
        ),
      ),
    );
  }
}
