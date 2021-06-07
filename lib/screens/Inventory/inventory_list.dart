import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/Providers/districtApiProvider.dart';
import 'package:FIS/services/Providers/forestApiProviders.dart';
import 'package:FIS/services/Providers/inventoryJobsApiProvider.dart';
import 'package:FIS/services/Providers/speciesApiProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:FIS/screens/Plot/plotScreen.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:FIS/services/model.dart';

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  int numberOfJobs = 0;
  String username = '';
  bool isLoading = false;
  List inventoryJobs = [];
  bool isStoring = false;
  double num1 = 0.01;
  double num2 = 0;
  double num3 = 0;
  double num4 = 0;
  int loaded = 0;
  String roles;
  int id = 0;
  bool statusvalue = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        username = prefs.getString('firstname').toString() +
            " " +
            prefs.getString('secondname').toString();
        roles = prefs.getString('roles').toString();
        print(roles);
        id = int.parse(prefs.getString('id'));
      });
    });
    statusfetch();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  Future<void> statusfetch() async {
    var x = await DBProvider.db.getstatusValue();

    if (x == '1') {
      setState(() {
        statusvalue = true;
      });
    }
  }

  Future<String> _loadFromApi() async {
    var apiProvider = ForestApiProvider();
    var x = await apiProvider.getAllForest();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));
    return x;
  }

  Future<String> _loadDistrictsFromApi() async {
    setState(() {
      isStoring = true;
    });
    var apiProvider = DistrictsApiProvider();
    var x = await apiProvider.getAllDistricts();
    await Future.delayed(const Duration(seconds: 1));
    return x;
  }

  Future<String> _loadSpeciesFromApi() async {
    var apiProvider = SpeciesApiProvider();

    var x = await apiProvider.getAllSpecies();
    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));
    return x;
  }

  Future<String> _loadInventoryFromApi() async {
    var apiProvider = InventoryJobApiProvider();
    var x = await apiProvider.getAllInventoryJobs(id);
    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));
    return x;
  }

  sum() {
    double x = num1;
    String perce = (x * 100).toString();
    return perce;
  }

// Function To Load Data From Database
  loadData() async {
    setState(() {
      loaded = 100;
      isStoring = true;
    });
    var x = await _loadSpeciesFromApi();
    await Future.delayed(const Duration(seconds: 3));

    print(x);
    if (x == "Success") {
      var y = await _loadFromApi();
      await Future.delayed(const Duration(seconds: 3));
      if (y == "Success") {
        var z = await _loadDistrictsFromApi();
        await Future.delayed(const Duration(seconds: 3));
        if (z == "Success") {
          var k = await _loadInventoryFromApi();
          if (k == "Success") {
            DBProvider.db.updateStatusValue();
            _showToast("All Resources Have Been Loaded Successfull");
          }

          setState(() {
            loaded = 100;
            isStoring = false;
          });
        }
      }
    }
    statusfetch();
    return _showToast('resources Have Not Been Looded Please Try Again');
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        webShowClose: true,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    //statusfetch();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(300),
            child: Stack(
              children: [
                Container(
                  height: getProportionateScreenHeight(300),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(86),
                        bottomRight: Radius.circular(86),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Logged In As: ' + username.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(20)),
                      ),
                      Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              color: Colors.white),
                          child: Tooltip(
                            message: 'Click Here To Load Resources',
                            child: statusvalue
                                ? Icon(
                                    Icons.supervised_user_circle_rounded,
                                    size: 30,
                                  )
                                : IconButton(
                                    icon: Icon(Icons.sync),
                                    onPressed: () => loadData()),
                          ))
                    ],
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      height: 54,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 10,
                                color: kPrimaryColor)
                          ]),
                      child: isStoring
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.cloud_download),
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: new LinearPercentIndicator(
                                    width: getProportionateScreenWidth(180),
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 2500,
                                    percent: num1 ?? num1,
                                    center: Text(
                                      sum() + '%',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: kPrimaryColor,
                                  ),
                                ),
                                num1 == 1
                                    ? Icon(
                                        Icons.verified_user,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.assignment_late,
                                        color: Colors.black,
                                      )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.filter_frames),
                                    Text(
                                      'Number Of Inventory Jobs',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenHeight(20),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                                Container(
                                    height: getProportionateScreenHeight(40),
                                    width: getProportionateScreenHeight(40),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        border: Border.all(
                                            color: Colors.green,
                                            style: BorderStyle.solid,
                                            width: 1),
                                        color: Colors.white),
                                    child: Center(
                                      child: isLoading
                                          ? Text(
                                              inventoryJobs.length.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Pacifico',
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              numberOfJobs.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Pacifico',
                                                  color: Colors.black),
                                            ),
                                    ))
                              ],
                            ),
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'List Of Inventory Jobs',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: getProportionateScreenHeight(20),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          isLoading
              ? CupertinoActivityIndicator(
                  animating: true,
                  radius: 20,
                )
              : _biuldInventoryListView()
        ],
      ),
    );
  }

// return a listview with Inventories
  _biuldInventoryListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllInventory(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: getProportionateScreenHeight(600),
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  print(snapshot.data.length);
                  setNumber(snapshot.data.length);
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, PlotScreen.routeName);
                      },
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          shadowColor: kPrimaryColor,
                          elevation: 5,
                          margin: EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PlotScreen.routeName,
                                arguments: ScreenArguments(
                                  snapshot.data[index].jobId,
                                  snapshot.data[index].numberOfPlots,
                                  snapshot.data[index].jobtype,
                                  id,
                                ),
                              );
                            },
                            child: ListTile(
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                                leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                title: Text(
                                    'Title: ${snapshot.data[index].title}'),
                                subtitle: Text(
                                    'Number Of Plots: ${snapshot.data[index].numberOfPlots}')),
                          ),
                        ),
                      ));
                }),
          );
        }
      },
    );
  }

  setNumber(int numb) {
    numberOfJobs = numb;
  }
}
