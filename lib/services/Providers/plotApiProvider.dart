import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';
import 'package:FIS/services/models/plotmodels.dart';
import 'package:http/http.dart' as http;

class PlotsApiProvider {
  Future<List<Plot>> getAllPlots(int id) async {
    var url = "https://mis.tfs.go.tz/fremis-test/api/v1/plots/$id";
    var response = await http.get(url);
    print(response.body);
    print(response.statusCode);
    var res = json.decode(response.body);
    // print(res);
    //  print(res['msg']);

    if (response.statusCode == 200) {
      // print(res);
      // var items = res['data'];
      // print(items);

      // // print(items);
      // setState(() {
      //   forestnames = items;
      //   isLoading = false;
      // });
      var result = (res['data'] as List).map((plot) {
        print('Inserting $plot');

        DBProvider.db.createPlots(Plot.fromJson(plot));
      }).toList();

      return result;
    } else {
      // forestnames = [];
      // isLoading = false;
    }
  }
}
