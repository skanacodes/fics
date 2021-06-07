import 'package:FIS/screens/tree_screen.dart/updateTree.dart';
import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:flutter/material.dart';

import 'package:FIS/services/constants.dart';
import 'package:FIS/services/model.dart';

import 'package:FIS/services/size_config.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TreeList extends StatefulWidget {
  final int id;
  TreeList(this.id);

  @override
  _TreeListState createState() => _TreeListState();
}

class _TreeListState extends State<TreeList> {
  bool isLoading = false;
  bool isDeleted = false;
  bool isUpdate = false;
  bool isDetails = false;
  List treeList = [];
  int jobId;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments1 args = ModalRoute.of(context).settings.arguments;
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: getProportionateScreenHeight(600),
            child: _biuldTreeListView(args.plotNumber, args.id, args.jobtype))
      ],
    );
  }

  _biuldTreeListView(String plotNo, int id, String jobtype) {
    return FutureBuilder(
      future: DBProvider.db.getAllTrees(id),
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
                      child: Center(
                          child: Text('Live Trees Have Not Been Added Yet'))),
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
                                              snapshot.data[index].plotId,
                                              snapshot.data[index].id,
                                              snapshot.data[index].treeNo,
                                              snapshot.data[index].stemNo,
                                              snapshot.data[index].speciesId,
                                              snapshot.data[index].height,
                                              snapshot.data[index].dbh,
                                              snapshot.data[index].boleheight,
                                              snapshot
                                                  .data[index].stumpDiameter,
                                              snapshot.data[index].stumpHeight,
                                              snapshot.data[index].remarks,
                                              snapshot.data[index].isAlive);
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
                                                title: Text('Tree Number: ' +
                                                    snapshot.data[index].treeNo
                                                        .toString()),
                                                subtitle: Text('dbh :' +
                                                    snapshot.data[index].dbh
                                                        .toString())),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: 'Update',
                                    color: Colors.black45,
                                    icon: Icons.update,
                                    onTap: () {
                                      return _updateTrees(
                                          snapshot.data[index].plotId,
                                          snapshot.data[index].id,
                                          snapshot.data[index].treeNo,
                                          snapshot.data[index].stemNo,
                                          snapshot.data[index].speciesId,
                                          snapshot.data[index].height,
                                          snapshot.data[index].dbh,
                                          snapshot.data[index].boleheight,
                                          snapshot.data[index].stumpDiameter,
                                          snapshot.data[index].stumpHeight,
                                          snapshot.data[index].remarks,
                                          snapshot.data[index].isAlive);
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
                                              deleteTree(id);
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

  _updateTrees(
    int plotId,
    int id,
    int treeNo,
    int stemNo,
    int speciesId,
    String height,
    String dbh,
    String boleheight,
    String stumpDiameter,
    String stumpHeight,
    String remarks,
    String isAlive,
  ) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  TreeUpdate(
                    id: id,
                    boleHeight: double.parse(boleheight),
                    dbh: double.parse(dbh),
                    height: double.parse(height),
                    isalive: isAlive,
                    plotId: plotId,
                    speciesId: speciesId,
                    stemno: stemNo,
                    stumpHeight: double.parse(stumpDiameter),
                    stumpdiameter: double.parse(stumpDiameter),
                    treeno: treeNo,
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

  deleteTree(var treeId) async {
    setState(() {
      isLoading = true;
    });
    var res = await DBProvider.db.deleteTree(treeId);
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
    int plotId,
    int id,
    int treeNo,
    int stemNo,
    int speciesId,
    String height,
    String dbh,
    String boleheight,
    String stumpDiameter,
    String stumpHeight,
    String remarks,
    String isAlive,
  ) {
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
                        'List Of Details You Entered For Tree Number ' +
                            treeNo.toString(),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.format_list_numbered),
                    title: new Text('Stem Number ' + stemNo.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                      leading: new Icon(Icons.location_on),
                      title: new Text('dbh: ' + dbh.toString()),
                      onTap: () => {}),
                  new ListTile(
                    leading: new Icon(Icons.fiber_manual_record),
                    title: new Text('heigth: ' + height.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.arrow_drop_up),
                    title: new Text('boleHeight: ' + boleheight.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.arrow_right),
                    title: new Text('Stump Heigth: ' + stumpHeight.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_size_select_large),
                    title:
                        new Text('Stump Diameter: ' + stumpDiameter.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.perm_data_setting),
                    title: new Text('Remarks: ' + remarks.toString()),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: new Icon(Icons.accessibility_outlined),
                    title: new Text('Tree Status: ' + isAlive),
                    onTap: () => {},
                  ),
                ],
              ),
            ),
          );
        });
  }
}
