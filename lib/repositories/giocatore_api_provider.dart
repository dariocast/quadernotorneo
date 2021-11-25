import 'dart:convert';

import 'package:http/http.dart';
import '../models/models.dart';

const String giocatoriUrl =
    'https://dariocast.altervista.org/fantazama/api/giocatore';
const String gruppiUrl =
    'https://dariocast.altervista.org/fantazama/api/gruppo';

class GiocatoreApiProvider {
  Client client = Client();
  Future<List<String>> giocatoriByGruppo(String gruppo) async {
    final response = await client.get(
        Uri.parse('$giocatoriUrl/getGiocatoriPerGruppo.php?gruppo=$gruppo'));
    if (response.statusCode == 200) {
      return List.from(json.decode(response.body));
    } else {
      throw Exception('Impossibile ottenere i giocatori');
    }
  }

  Future<List<Gruppo>> gruppi() async {
    final response = await client.get(Uri.parse('$gruppiUrl/getGruppi.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map<Gruppo>((json) => Gruppo.fromMap(json))
          .toList();
    } else {
      throw Exception('Impossibile ottenere i gruppi');
    }
  }

  Future<List<Giocatore>> marcatori() async {
    final response =
        await client.get(Uri.parse('$giocatoriUrl/getOrdered.php'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map<Giocatore>((json) => Giocatore.fromMap(json))
          .toList();
    } else {
      throw Exception('Impossibile ottenere i marcatori');
    }
  }

  Future<Giocatore> creaGiocatore(
      String nome, String gruppo, int immagine) async {
    final response = await client.post(Uri.parse('$giocatoriUrl/create.php'),
        body: jsonEncode({
          'nome': nome,
          'gruppo': gruppo,
          'image': immagine,
        }));
    if (response.statusCode == 200) {
      return Giocatore.fromJson(response.body);
    } else {
      throw Exception('Impossibile creare nuovo giocatore');
    }
  }

  Future<bool> aggiorna(Giocatore giocatore) async {
    final response = await client.post(Uri.parse('$giocatoriUrl/update.php'),
        body: giocatore.toJson());
    if (response.statusCode == 200) {
      return json.decode(response.body)['updated'];
    } else {
      throw Exception('Impossibile aggiornare il giocatore');
    }
  }

  Future<bool> elimina(int id) async {
    final response =
        await client.delete(Uri.parse('$giocatoriUrl/delete.php?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['deleted'];
    } else {
      throw Exception('Impossibile eliminare il giocatore');
    }
  }

  Future<List<Giocatore>> tutti() async {
    final response = await client.get(Uri.parse('$giocatoriUrl/getAll.php'));
    if (response.statusCode == 200) {
      final jsonDecoded = jsonDecode(response.body);
      final mapDone =
          jsonDecoded.map<Giocatore>((json) => Giocatore.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } else {
      throw Exception('Impossibile caricare i giocatori');
    }
  }

  Future<Giocatore> singolo(int id) async {
    final response =
        await client.get(Uri.parse('$giocatoriUrl/get.php?id=$id'));
    if (response.statusCode == 200) {
      return Giocatore.fromJson(response.body);
    } else {
      throw Exception('Impossibile caricare il giocatore con id: $id');
    }
  }
}
