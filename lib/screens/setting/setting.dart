import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/plotmodels.dart';
import 'package:FIS/services/size_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:FIS/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

class Setting extends StatefulWidget {
  static String routeName = "/setting";
  final Plot listModel = Plot();

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool setprogressbar = false;
  int num1 = 0;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Uploading Data To The Server..."),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundedLoadingButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('Upload Plot Details',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                                controller: _btnController,
                                height: getProportionateScreenHeight(60),
                                color: kPrimaryColor,
                                onPressed: savePlotsToApi),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            RoundedLoadingButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.cloud_upload_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('Upload Tree Details!',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                                elevation: 20,
                                animateOnTap: true,
                                curve: Curves.easeInOutSine,
                                controller: _btnController,
                                height: getProportionateScreenHeight(60),
                                color: kPrimaryColor,
                                onPressed: saveTreesToApi),
                            // RoundedLoadingButton(
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     children: [
                            //       CircleAvatar(
                            //         backgroundColor: Colors.white,
                            //         radius: 20,
                            //         child: Icon(
                            //           Icons.cloud_upload_outlined,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       Text('Upload Plot Details!',
                            //           style: TextStyle(color: Colors.black)),
                            //     ],
                            //   ),
                            //   controller: _btnController,
                            //   height: getProportionateScreenHeight(60),
                            //   color: kPrimaryColor,
                            //   onPressed: () async {
                            //     setState(() {
                            //       setprogressbar = true;
                            //     });
                            //     var res =
                            //         await DBProvider.db.getAllPlotsDetails();
                            //     savePlotsToApi(res);
                            //   },
                            // ),
                          ],
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close")),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sync Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            buildAccountOptionRow(context, "Clear Cache"),
            buildAccountOptionRow(context, "Content settings"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and security"),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("New for you", true),
            buildNotificationOptionRow("Account activity", true),
            buildNotificationOptionRow("Opportunity", false),
            SizedBox(
              height: 50,
            ),
            Center(
              child: OutlineButton(
                padding: EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
                child: Text("SIGN OUT",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void saveTreesToApi() async {
    setState(() {
      setprogressbar = true;
    });

    var res = await DBProvider.db.getAllTreesDetails();
    List chckList = res.map((e) => json.encode(e.toJson())).toList();
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    //print(jsonDecode(body));
    const url = 'https://mis.tfs.go.tz/fremis-test/api/v1/tree/create';
    try {
      print(chckList);
      http.Response response = await http.post(
        url,
        headers: headers,
        body: chckList.toString(),
      );

      if (response.statusCode == 201) {
        setState(() {
          setprogressbar = false;
        });
        String data = response.body;

        jsonDecode(data);
        print(data);
        print(response.statusCode);
        _btnController.success();
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        setState(() {
          setprogressbar = false;
        });
        _btnController.error();
      }
    } catch (error) {
      print(error);
      setState(() {
        setprogressbar = false;
      });
      _btnController.error();
    }
  }

  savePlotsToApi() async {
    setState(() {
      setprogressbar = true;
    });
    var res = await DBProvider.db.getAllPlotsDetails();
    List chckList = res.map((e) => json.encode(e.toJson())).toList();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    //print(jsonDecode(body));
    const url = 'https://mis.tfs.go.tz/fremis-test/api/v1/plots/create';
    try {
      print(chckList);
      http.Response response = await http.post(
        url,
        headers: headers,
        body: chckList.toString(),
      );

      if (response.statusCode == 201) {
        setState(() {
          setprogressbar = false;
          num1 = 1;
        });
        String data = response.body;
        _btnController.success();
        jsonDecode(data);
        print(data);
        print(response.statusCode);
      } else {
        print(response.statusCode);
        print(jsonDecode(response.body));
        _btnController.error();
        setState(() {
          setprogressbar = false;
          num1 = 0;
        });
      }
    } catch (error) {
      _btnController.error();
      setState(() {
        setprogressbar = false;
        num1 = 0;
      });
    }
  }
}
