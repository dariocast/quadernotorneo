import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

const String partitaUrl =
    'https://dariocast.altervista.org/fantazama/api/partita';

class PartitaApiProvider {
  Client client = Client();
  Future<List<PartitaModel>> tutte() async {
    final response = await client.get(Uri.parse('$partitaUrl/getAll.php'));
    if (response.statusCode == 200) {
      final jsonDecoded = jsonDecode(response.body);
      final mapDone =
          jsonDecoded.map<PartitaModel>((json) => PartitaModel.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } else {
      throw Exception('Impossibile caricare le partite');
    }
  }

  Future<PartitaModel> singola(int id) async {
    final response = await client.get(Uri.parse('$partitaUrl/get.php?id=$id'));
    if (response.statusCode == 200) {
      return PartitaModel.fromJson(response.body);
    } else {
      throw Exception('Impossibile caricare la partita con id: $id');
    }
  }

  Future<PartitaModel> crea(
      String squadra1, String squadra2, DateTime data) async {
    // final response = await client.post(Uri.parse('$partitaUrl/create.php'),
    //     body: jsonEncode({
    //       'squadraUno': squadra1,
    //       'squadraDue': squadra2,
    //       'data': data.millisecondsSinceEpoch / 1000,
    //     }));
    final supabase = Supabase.instance.client;
    final response = await supabase.from('partita').insert({
      'squadraUno': squadra1,
      'squadraDue': squadra2,
      'data': data.millisecondsSinceEpoch / 1000
    }).execute();
    final error = response.error;
    if (response.status == 200) {
      return PartitaModel.fromJson(response.data);
    } else {
      throw Exception('Impossibile creare la partita: error: ${error}');
    }
  }

  Future<bool> aggiorna(PartitaModel partita) async {
    final response = await client.post(Uri.parse('$partitaUrl/update.php'),
        body: partita.toJson());
    if (response.statusCode == 200) {
      return json.decode(response.body)['updated'];
    } else {
      throw Exception('Impossibile aggiornare la partita');
    }
  }

  Future<bool> elimina(int id) async {
    final response =
        await client.delete(Uri.parse('$partitaUrl/delete.php?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['deleted'];
    } else {
      throw Exception('Impossibile eliminare la partita');
    }
  }
}
