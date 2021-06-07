import 'package:FIS/screens/Deadwood/deadwoodlist.dart';
import 'package:FIS/screens/Deadwood/deadwoodformscreen.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';

class DeadWoodScreen extends StatefulWidget {
  static String routeName = '/deadwood';
  @override
  _DeadWoodScreenState createState() => _DeadWoodScreenState();
}

class _DeadWoodScreenState extends State<DeadWoodScreen> {
  bool isGreentab1 = true;
  bool isGreentab2 = false;
  bool isList = true;
  bool isList2 = false;
  int plotids;

  void updateInformation(int information) {
    setState(() => plotids = information);
  }

  void moveToSecondPage(int id, int plotnpo, String jobtype) async {
    final information =
        await Navigator.pushNamed(context, DeadWoodFormScreen.routeName,
            arguments: ScreenArguments1(
              plotids ?? id,
              plotnpo.toString(),
              jobtype,
            ));
    updateInformation(information);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments1 args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Of DeadWoods',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Add Dead Wood',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        tooltip: 'Add Dead Wood',
        onPressed: () {
          moveToSecondPage(
            args.id,
            int.parse(args.plotNumber),
            args.jobtype,
          );
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
                      'List Of Registered Dead Woods',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            DeadWoodList(args.id),
          ],
        ),
      ),
    );
  }
}
