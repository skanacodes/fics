import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/model.dart';
import 'package:FIS/services/constants.dart';
import 'package:FIS/services/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeadWoodList extends StatefulWidget {
  final int id;
  DeadWoodList(this.id);
  @override
  _DeadWoodListState createState() => _DeadWoodListState();
}

class _DeadWoodListState extends State<DeadWoodList> {
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
            child:
                _biuldDeadWoodListView(args.plotNumber, args.id, args.jobtype))
      ],
    );
  }

  _biuldDeadWoodListView(String plotNo, int id, String jobtype) {
    return FutureBuilder(
      future: DBProvider.db.getAllDeadWoods(),
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
                                          // _viewDetailsBottomSheet(
                                          //     context,
                                          //     snapshot.data[index].plotNo,
                                          //     snapshot.data[index].id,
                                          //     snapshot.data[index].plotArea,
                                          //     snapshot.data[index].jobId,
                                          //     snapshot.data[index].eastings,
                                          //     snapshot.data[index].northings,
                                          //     snapshot.data[index].plotsize,
                                          //     snapshot.data[index].slope,
                                          //     snapshot
                                          //         .data[index].radiusCollection,
                                          //     snapshot.data[index].altitude,
                                          //     snapshot.data[index].measurer,
                                          //     snapshot
                                          //         .data[index].vegetationType,
                                          //     plotNo,
                                          //     snapshot.data[index].districtId,
                                          //     snapshot.data[index].forestId,
                                          //     snapshot.data[index].plotDate);
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
                                                title: Text(
                                                    'DeadWood Number: ' +
                                                        snapshot.data[index]
                                                            .deadWoodNo
                                                            .toString()),
                                                subtitle: Text('Stem No :' +
                                                    snapshot.data[index].stemNo
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
                                      // return _updatePlots(
                                      //     snapshot.data[index].plotNo,
                                      //     snapshot.data[index].id,
                                      //     snapshot.data[index].plotArea,
                                      //     snapshot.data[index].jobId,
                                      //     snapshot.data[index].eastings,
                                      //     snapshot.data[index].northings,
                                      //     snapshot.data[index].plotsize,
                                      //     snapshot.data[index].slope,
                                      //     snapshot.data[index].radiusCollection,
                                      //     snapshot.data[index].altitude,
                                      //     snapshot.data[index].measurer,
                                      //     snapshot.data[index].vegetationType,
                                      //     plotNo,
                                      //     snapshot.data[index].districtId,
                                      //     snapshot.data[index].forestId,
                                      //     snapshot.data[index].plotDate);
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
}
