import 'dart:convert';

import 'package:quaderno_flutter/src/models/models.dart';
import 'package:http/http.dart' show Client;

const String baseUrl = 'https://dariocast.altervista.org/fantazama/api/partita';

class PartitaApiProvider {
  Client client = Client();
  Future<List<PartitaModel>> tutte() async {
    final response = await client.get(baseUrl + '/getAll.php');
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<PartitaModel>((json) => PartitaModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Impossibile caricare le partite');
    }
  }

  Future<PartitaModel> singola(int id) async {
    final response = await client.get(baseUrl + '/get.php?id=$id');
    if (response.statusCode == 200) {
      return PartitaModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Impossibile caricare la partita con id: $id');
    }
  }

  Future<PartitaModel> crea(String squadra1, String squadra2) async {
    final response = await client.post(baseUrl + '/create.php',
        body: {'squadraUno': squadra1, 'squadraDue': squadra2});
    if (response.statusCode == 200) {
      return PartitaModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Impossibile creare la partita');
    }
  }

  Future<bool> aggiorna(PartitaModel partita) async {
    final response =
        await client.post(baseUrl + '/update.php', body: partita.toJson());
    if (response.statusCode == 200) {
      return json.decode(response.body)['updated'];
    } else {
      throw Exception('Impossibile aggiornare la partita');
    }
  }

  Future<bool> elimina(int id) async {
    final response = await client.delete(baseUrl + '/delete.php?id=$id');
    if (response.statusCode == 200) {
      return json.decode(response.body)['deleted'];
    } else {
      throw Exception('Impossibile eliminare la partita');
    }
  }
}
