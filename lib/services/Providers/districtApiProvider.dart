import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/districtmodels.dart';

import 'package:http/http.dart' as http;

class DistrictsApiProvider {
  Future<String> getAllDistricts() async {
    try {
      var url = "https://mis.tfs.go.tz/fremis-test/api/v1/get-districts";
      var response = await http.get(url);
      print(response.body);
      print(response.statusCode);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        var result = (res['data'] as List).map((dist) {
          print('Inserting $dist');

          DBProvider.db.createDistricts(Districts.fromJson(dist));
        }).toList();
        print(result);
        return 'Success';
      } else {
        return null;
      }
    } catch (e) {
      return 'Failed';
    }
  }
}
