import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../models/gruppo.dart';

const String gruppiUrl =
    'https://dariocast.altervista.org/fantazama/api/gruppo';

class GruppoApiProvider {
  Client client = Client();
  Future<List<Gruppo>> gruppi() async {
    final response = await client.get(Uri.parse('$gruppiUrl/getAll.php'));
    if (response.statusCode == 200) {
      final jsonDecoded = jsonDecode(response.body);
      final mapDone = jsonDecoded.map<Gruppo>((json) => Gruppo.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } else {
      throw Exception('Impossibile caricare le partite');
    }
  }

  Future<Gruppo> singolo(int id) async {
    final response = await client.get(Uri.parse('$gruppiUrl/get.php?id=$id'));
    if (response.statusCode == 200) {
      return Gruppo.fromJson(response.body);
    } else {
      throw Exception('Impossibile caricare il gruppo con id: $id');
    }
  }

  Future<Gruppo> getByNome(String nome) async {
    final response =
        await client.get(Uri.parse('$gruppiUrl/get.php?nome=$nome'));
    if (response.statusCode == 200) {
      return Gruppo.fromJson(response.body);
    } else {
      throw Exception('Impossibile caricare il gruppo con nome: $nome');
    }
  }

  Future<Gruppo> crea(String squadra1, String squadra2, DateTime data) async {
    final response = await client.post(Uri.parse('$gruppiUrl/create.php'),
        body: jsonEncode({
          'squadraUno': squadra1,
          'squadraDue': squadra2,
          'data': data.millisecondsSinceEpoch / 1000,
        }));
    if (response.statusCode == 200) {
      return Gruppo.fromJson(response.body);
    } else {
      throw Exception('Impossibile creare il gruppo');
    }
  }

  Future<bool> aggiorna(Gruppo gruppo) async {
    final response = await client.post(Uri.parse('$gruppiUrl/update.php'),
        body: gruppo.toJson());
    if (response.statusCode == 200) {
      return json.decode(response.body)['updated'];
    } else {
      throw Exception('Impossibile aggiornare il gruppo');
    }
  }

  Future<bool> elimina(int id) async {
    final response =
        await client.delete(Uri.parse('$gruppiUrl/delete.php?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['deleted'];
    } else {
      throw Exception('Impossibile eliminare il gruppo');
    }
  }
}
