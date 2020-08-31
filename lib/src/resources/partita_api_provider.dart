import 'dart:convert';

import 'package:quaderno_flutter/src/models/partita_model.dart';
import 'package:http/http.dart' show Client;

const String baseUrl = 'https://dariocast.altervista.org/fantazama/api';

class PartitaApiProvider {
  Client client = Client();
  // Gruppo api
  Future<List<PartitaModel>> getPartite() async {
    final response = await client.get(baseUrl + '/partita/getAll.php');
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<PartitaModel>((json) => PartitaModel.fromJson(json))
        .toList();
  }
}
