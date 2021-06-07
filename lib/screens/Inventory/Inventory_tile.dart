import 'package:FIS/services/constants.dart';
import 'package:flutter/material.dart';

class InventoryTile extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: kPrimaryColor,
        elevation: 5,
        margin: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {},
          child: InkWell(
            onTap: () {},
            child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.work,
                    color: Colors.black,
                  ),
                ),
                title: Text('Purpose: '),
                subtitle: Text('Issued :')),
          ),
        ),
      ),
    );
  }
}
