import 'package:FIS/screens/Inventory/drawer.dart';
import 'package:FIS/screens/Inventory/inventory_list.dart';
import 'package:FIS/services/constants.dart';
import 'package:flutter/material.dart';

class InventoryListScreen extends StatelessWidget {
  static String routeName = "/inventory";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          'Forest Inventory System',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: InventoryList(),
    );
  }
}
