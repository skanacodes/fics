import 'package:FIS/screens/Plot/Plot_list.dart';
import 'package:FIS/screens/Plot/plotformScreen.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';

class PlotScreen extends StatefulWidget {
  static String routeName = "/plot";
  @override
  _PlotScreenState createState() => _PlotScreenState();
}

class _PlotScreenState extends State<PlotScreen> {
  bool isGreentab1 = true;
  bool isGreentab2 = false;
  bool isList = true;
  bool isList2 = false;
  int jobids;

  void updateInformation(int information) {
    setState(() => jobids = information);
  }

  void moveToSecondPage(int jobid, int plotnpo, String jobtype, int pId) async {
    final information = await Navigator.pushNamed(
        context, PlotFormScreen.routeName,
        arguments: ScreenArguments(jobids ?? jobid, plotnpo, jobtype, pId));
    updateInformation(information);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plots Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Add Plot',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Add Plot',
        onPressed: () {
          moveToSecondPage(args.jobid, args.plotNumber, args.jobtype, args.pId);
          //  _loadFromApi(args.jobid);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: getProportionateScreenHeight(120),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(getProportionateScreenHeight(100)),
                      bottomRight:
                          Radius.circular(getProportionateScreenHeight(100)))),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(350),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color: kPrimaryColor)
                      ]),
                  child: Center(
                    child: Text(
                      'List Of Registered Plots',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            PlotsList(args.jobid, args.plotNumber, args.jobtype),
          ],
        ),
      ),
    );
  }
}
