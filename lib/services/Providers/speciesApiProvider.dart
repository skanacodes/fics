import 'dart:convert';

import 'package:FIS/services/Providers/db_Provider.dart';

import 'package:FIS/services/models/speciesmodels.dart';
import 'package:http/http.dart' as http;

class SpeciesApiProvider {
  Future<String> getAllSpecies() async {
    try {
      var url = "https://mis.tfs.go.tz/fremis-test/api/v1/get-species";
      var response = await http.get(url);
      print(response.body);
      print(response.statusCode);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        var result = (res['data'] as List).map((species) {
          print('Inserting $species');

          DBProvider.db.createSpecies(Species.fromJson(species));
        }).toList();
        return 'Success';
      } else {
        print('data wasnt added');
        return null;
      }
    } catch (e) {
      return 'Failed';
    }
  }
}
