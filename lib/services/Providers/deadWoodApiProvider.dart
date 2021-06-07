import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/plotmodels.dart';
import 'package:http/http.dart' as http;

class PlotsApiProvider {
  Future<List<Plot>> getAllPlots(int id) async {
    var url = "https://mis.tfs.go.tz/fremis-test/api/v1/dead-wood/store";
    var response = await http.get(url);
    print(response.body);
    print(response.statusCode);
    var res = json.decode(response.body);

    if (response.statusCode == 200) {
      var result = (res['data'] as List).map((plot) {
        print('Inserting $plot');

        DBProvider.db.createPlots(Plot.fromJson(plot));
      }).toList();

      return result;
    } else {}
  }
}
