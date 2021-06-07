import 'package:FIS/screens/tree_screen.dart/RegisterTreeScreen.dart';

import 'package:FIS/screens/tree_screen.dart/treeList.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:FIS/services/model.dart';

class RegisterTree extends StatefulWidget {
  static String routeName = "/registerTree";
  @override
  _RegisterTreeState createState() => _RegisterTreeState();
}

class _RegisterTreeState extends State<RegisterTree> {
  bool isGreentab1 = true;
  bool isGreentab2 = false;
  bool isList = true;
  bool isList2 = false;
  int plotids;

  void updateInformation(int information) {
    setState(() => plotids = information);
  }

  void moveToSecondPage(int id, String plotnpo, String jobtype) async {
    final information = await Navigator.pushNamed(
        context, RegisterTreeScreen.routeName,
        arguments: ScreenArguments1(plotids ?? id, plotnpo, jobtype));
    updateInformation(information);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments1 args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Of Live Trees',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Add Live Tree',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Add Tree',
        onPressed: () {
          Navigator.pushNamed(context, RegisterTreeScreen.routeName,
              arguments:
                  ScreenArguments1(args.id, args.plotNumber, args.jobtype));
          moveToSecondPage(args.id, args.plotNumber, args.jobtype);
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
                      'List Of Registered Trees',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            TreeList(args.id),
          ],
        ),
      ),
    );
  }
}
