import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' show Client;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

class PartitaApiProvider {
  Client client = Client();
  Future<List<PartitaModel>> tutte() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('partita').select('*').execute();
    final error = response.error;

    if (error != null && response.status != 200) {
      throw Exception('Impossibile caricare le partite');
    } else {
      final listaPartiteDB = response.data as List;
      final mapDone = listaPartiteDB
          .map<PartitaModel>((json) => PartitaModel.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    }
  }

  Future<PartitaModel> singola(int id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('partita').select('*').eq('id', id).execute();
    final error = response.error;
    if (error != null && response.status != 200) {
      throw Exception('Impossibile caricare la partita con id: $id');
    } else {
      return PartitaModel.fromMap(response.data[0]);
    }
  }

  Future<PartitaModel> crea(
      String squadra1, String squadra2, DateTime data) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('partita').insert({
      'squadraUno': squadra1,
      'squadraDue': squadra2,
      'marcatori': List.empty(),
      'ammoniti': List.empty(),
      'espulsi': List.empty(),
      'data': data.toIso8601String()
    }).execute();
    final error = response.error;
    if (error != null && response.status != 200) {
      throw Exception('Impossibile creare la partita: error: ${error}');
    } else {
      return PartitaModel.fromMap(response.data[0]);
    }
  }

  Future<bool> aggiorna(PartitaModel partita) async {
    // final response = await client.post(Uri.parse('$partitaUrl/update.php'),
    //     body: partita.toJson());

    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('partita')
        .update({
          'squadraUno': partita.squadraUno,
          'squadraDue': partita.squadraDue,
          'golSquadraUno': partita.golSquadraUno,
          'golSquadraDue': partita.golSquadraDue,
          'falliSquadraUno': partita.falliSquadraUno,
          'falliSquadraDue': partita.falliSquadraDue,
          'marcatori': partita.marcatori,
          'ammoniti': partita.ammoniti,
          'espulsi': partita.espulsi,
          'data': partita.data.toIso8601String()
        })
        .eq('id', partita.id)
        .execute();
    final error = response.error;
    return error != null && response.status != 200
        ? throw Exception('Impossibile aggiornare la partita')
        : true;
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('partita').delete().eq('id', id).execute();
    final partitaEliminata = PartitaModel.fromMap(response.data[0]);
    developer.log('Partita rimossa', name: 'repositories.partita.delete');
    final error = response.error;
    return error != null && response.status != 200
        ? throw Exception('Impossibile eliminare la partita')
        : true;
  }
}
