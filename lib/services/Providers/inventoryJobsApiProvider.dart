import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';

import 'package:FIS/services/models/inventorymodels.dart';
import 'package:http/http.dart' as http;

class InventoryJobApiProvider {
  Future<String> getAllInventoryJobs(int id) async {
    try {
      var url = "https://mis.tfs.go.tz/fremis-test/api/v1/inventory-job/$id";
      var response = await http.get(url);
      print(response.body);
      print(response.statusCode);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        var result = (res['data'] as List).map((inventory) {
          print('Inserting $inventory');

          DBProvider.db.createInventoryJobs(Inventory.fromJson(inventory));
        }).toList();
        return 'Success';
      } else {
        return null;
      }
    } catch (e) {
      return 'Failed';
    }
  }
}
