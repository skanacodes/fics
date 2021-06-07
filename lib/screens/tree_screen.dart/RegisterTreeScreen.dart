import 'package:FIS/screens/tree_screen.dart/register_tree_form.dart';
import 'package:FIS/screens/tree_screen.dart/plantation_form.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';

class RegisterTreeScreen extends StatefulWidget {
  static String routeName = "/registerTreeForm";
  @override
  _RegisterTreeScreenState createState() => _RegisterTreeScreenState();
}

class _RegisterTreeScreenState extends State<RegisterTreeScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenArguments1 args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, args.id),
        ),
        title: Text(
          'Enter Tree Details',
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
                        backgroundImage:
                            AssetImage('assets/images/deadwood.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: args.jobtype == 'plantation'
                  ? PlantationForm(args.id)
                  : NaturalForestForm(args.id),
            ),
          ],
        ),
      ),
    );
  }
}
