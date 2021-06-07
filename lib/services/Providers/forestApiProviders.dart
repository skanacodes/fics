import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/forestmodels.dart';
import 'package:http/http.dart' as http;

class ForestApiProvider {
  Future<String> getAllForest() async {
    try {
      var url = "https://mis.tfs.go.tz/fremis-test/api/v1/get-forest";
      var response = await http.get(url);
      print(response.body);
      print(response.statusCode);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        var result = (res['data'] as List).map((forest) {
          print('Inserting $forest');

          DBProvider.db.createForest(Forest.fromJson(forest));
        }).toList();
        print('Data Has been Added' + result.toString());
        return 'Success';
      } else {
        print('Inserting Forest Failed');
        return null;
      }
    } catch (e) {
      return 'Failed';
    }
  }
}
