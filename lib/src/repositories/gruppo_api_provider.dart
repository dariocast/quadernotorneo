import 'dart:convert';

import 'package:quaderno_flutter/src/models/models.dart';
import 'package:http/http.dart' show Client;

const String baseUrl = 'https://dariocast.altervista.org/fantazama/api';

class GruppoApiProvider {
  Client client = Client();
  // Gruppo api
  Future<List<GruppoModel>> getGruppi() async {
    final response = await client.get(baseUrl + '/gruppo/getGruppi.php');
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<GruppoModel>((json) => GruppoModel.fromJson(json))
        .toList();
  }
}
