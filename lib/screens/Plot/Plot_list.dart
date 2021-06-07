import 'package:FIS/screens/Deadwood/deadwoodscreen.dart';
import 'package:FIS/screens/Plot/plotupdate.dart';
import 'package:FIS/screens/tree_screen.dart/register_tree.dart';
import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlotsList extends StatefulWidget {
  final int id;
  final int plotNo;
  final String jobtype;
  PlotsList(this.id, this.plotNo, this.jobtype);
  @override
  _PlotsListState createState() => _PlotsListState();
}

class _PlotsListState extends State<PlotsList> {
  bool isLoading = false;
  bool isDeleted = false;
  bool isUpdate = false;
  bool isDetails = false;
  List plots = [];
  int jobId;
  int plotNo;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        // jobids = int.parse(prefs.getString('jobid'));
      });
    });
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: getProportionateScreenHeight(600),
            child:
                _biuldPlotsListView(args.plotNumber, args.jobid, args.jobtype))
      ],
    );
  }

  _biuldPlotsListView(int plotNo, int jobid, String jobtype) {
    return FutureBuilder(
      future: DBProvider.db.getAllPlots(jobid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return CupertinoActivityIndicator(
            animating: true,
            radius: 20,
          );
        } else {
          return snapshot.data.length == 0
              ? Container(
                  margin: EdgeInsets.all(getProportionateScreenHeight(20)),
                  // padding: EdgeInsets.all(10),

                  child: Center(
                      child:
                          Center(child: Text('Plots Have Not Been Added Yet'))),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: getProportionateScreenHeight(600),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        print(snapshot.data.length);
                        // setNumber(snapshot.data.length);
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            child: InkWell(
                              onTap: () {},
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: Container(
                                    child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      shadowColor: kPrimaryColor,
                                      elevation: 5,
                                      margin: EdgeInsets.all(8),
                                      child: InkWell(
                                        onTap: () {
                                          _viewDetailsBottomSheet(
                                              context,
                                              snapshot.data[index].plotNo,
                                              snapshot.data[index].id,
                                              snapshot.data[index].plotArea,
                                              snapshot.data[index].jobId,
                                              snapshot.data[index].eastings,
                                              snapshot.data[index].northings,
                                              snapshot.data[index].plotsize,
                                              snapshot.data[index].slope,
                                              snapshot
                                                  .data[index].radiusCollection,
                                              snapshot.data[index].altitude,
                                              snapshot.data[index].measurer,
                                              snapshot
                                                  .data[index].vegetationType,
                                              plotNo,
                                              snapshot.data[index].districtId,
                                              snapshot.data[index].plotDate);
                                        },
                                        child: Column(
                                          children: [
                                            ListTile(
                                                trailing: Icon(
                                                  Icons.arrow_drop_down_circle,
                                                  color: Colors.black,
                                                ),
                                                leading: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  child: Icon(
                                                    Icons.wrap_text,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                title: Text('Plot Number: ' +
                                                    snapshot.data[index].plotNo
                                                        .toString()),
                                                subtitle: Text(
                                                    'Inventory Date :' +
                                                        snapshot.data[index]
                                                            .plotDate
                                                            .toString())),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Live Tree',
                                    color: Colors.blue,
                                    icon: Icons.ac_unit,
                                    onTap: () {
                                      return Navigator.pushNamed(
                                          context, RegisterTree.routeName,
                                          arguments: ScreenArguments1(
                                              snapshot.data[index].id,
                                              snapshot.data[index].plotNo,
                                              jobtype));
                                    },
                                  ),
                                  IconSlideAction(
                                      caption: 'Dead Wood',
                                      color: Colors.indigo,
                                      icon: Icons.cancel,
                                      onTap: () => Navigator.pushNamed(
                                          context, DeadWoodScreen.routeName,
                                          arguments: ScreenArguments1(
                                              snapshot.data[index].id,
                                              snapshot.data[index].plotNo,
                                              jobtype))),
                                ],
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Update',
                                    color: Colors.black45,
                                    icon: Icons.update,
                                    onTap: () {
                                      return _updatePlots(
                                          snapshot.data[index].plotNo,
                                          snapshot.data[index].id,
                                          snapshot.data[index].plotArea,
                                          snapshot.data[index].jobId,
                                          snapshot.data[index].eastings,
                                          snapshot.data[index].northings,
                                          snapshot.data[index].plotsize,
                                          snapshot.data[index].slope,
                                          snapshot.data[index].radiusCollection,
                                          snapshot.data[index].altitude,
                                          snapshot.data[index].measurer,
                                          snapshot.data[index].vegetationType,
                                          plotNo,
                                          snapshot.data[index].districtId,
                                          snapshot.data[index].plotDate);
                                    },
                                  ),
                                  IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () {
                                      return Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: "Warning",
                                        desc:
                                            "Are You Sure You Want To Delete This.",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              var id = snapshot.data[index].id;
                                              deletePlot(id);
                                            },
                                            color: kPrimaryColor,
                                          ),
                                          DialogButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: Colors.red,
                                          )
                                        ],
                                      ).show();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
        }
      },
    );
  }

  _updatePlots(
      String plotnumber,
      int plotId,
      String plotarea,
      int jobid,
      String eastings,
      String northing,
      int plotsize,
      String slop,
      String radiuscollection,
      int altitude,
      String measurer,
      String vegtype,
      int noOfPlots,
      int districtId,
      String finaldate) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  PlotUpdate(
                    plotnumber: plotnumber,
                    altitude: altitude,
                    eastings: eastings,
                    jobid: jobid,
                    measurer: measurer,
                    northings: northing,
                    plotId: plotId,
                    plotarea: plotarea,
                    plotsize: plotsize,
                    radiuscollection: radiuscollection,
                    slop: slop,
                    vegtype: vegtype,
                    numberOfPlots: noOfPlots,
                    disrictId: districtId,
                    finaldate: finaldate,
                  )
                ],
              ),
            ),
          );
        });
  }

  showDetails() {
    return Container(
      height: 300,
    );
  }

  deletePlot(var plotId) async {
    print('PRINT' + plotId.toString());
    setState(() {
      isLoading = true;
    });
    var res = await DBProvider.db.deletePlot(plotId);
    if (res == 'Success') {
      setState(() {
        isDeleted = false;
      });
      Alert(
              type: AlertType.success,
              context: context,
              title: "Information",
              desc: "Plot Deleted Successful.")
          .show();
    } else {
      setState(() {
        isDeleted = false;
      });
      Alert(
              context: context,
              title: "Information",
              desc: "Failed To Plot Deleted ")
          .show();
      // plots = [];
      // isLoading = false;
    }
  }

  void _viewDetailsBottomSheet(
      context,
      String plotnumber,
      int plotId,
      String plotarea,
      int jobid,
      String eastings,
      String northing,
      int plotsize,
      String slop,
      String radiuscollection,
      int altitude,
      String measurer,
      String vegtype,
      int noOfPlots,
      int districtId,
      String finaldate) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'List Of Details You Entered For Plot Number ' +
                            plotnumber.toString(),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.format_list_numbered),
                    title: new Text('Plot Number ' +
                        plotnumber.toString() +
                        " " +
                        "Of" +
                        " " +
                        noOfPlots.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                      leading: new Icon(Icons.location_on),
                      title: new Text('District Name: '),
                      onTap: () => {}),
                  new ListTile(
                    leading: new Icon(Icons.fiber_manual_record),
                    title: new Text('Plot Area: ' + plotarea.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.arrow_drop_up),
                    title: new Text('Northings: ' + northing.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.arrow_right),
                    title: new Text('Eastings: ' + eastings.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_size_select_large),
                    title: new Text('Plot Size: ' + plotsize.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.perm_data_setting),
                    title: new Text('slope: ' + slop.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.adjust),
                    title: new Text('Altitude ' + altitude.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.blur_circular),
                    title: new Text(
                        'Radius Correction: ' + radiuscollection.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.build),
                    title: new Text('Measurer: ' + measurer.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.ac_unit),
                    title: new Text('Vegetation Type: ' + vegtype),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.calendar_today),
                    title: new Text('Date: ' + finaldate),
                    onTap: () => {},
                  ),
                ],
              ),
            ),
          );
        });
  }
}
