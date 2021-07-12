import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:quaderno_flutter/models/models.dart';

const String adminUrl = 'https://dariocast.altervista.org/fantazama/api/admin';

class AdminApiProvider {
  Client client = Client();

  Future<bool> aggiornaClassifica() async {
    final response = await client
        .get(Uri.parse('$adminUrl/aggiornaClassifica.php?password=centroZAMA'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['updated'];
    } else {
      throw Exception('Impossibile aggiornare la classifica');
    }
  }

  Future<List<Marcatore>> aggiornaMarcatori() async {
    final response =
        await client.post(Uri.parse('$adminUrl/aggiornaMarcatori.php'));
    if (response.statusCode == 200) {
      final jsonDecoded = jsonDecode(response.body);
      final mapDone =
          jsonDecoded.map<Marcatore>((json) => Marcatore.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } else {
      throw Exception('Impossibile aggiornare i marcatori');
    }
  }
}
