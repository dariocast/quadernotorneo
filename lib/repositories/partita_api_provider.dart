// ignore_for_file: unused_local_variable

import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/log_helper.dart';

class PartitaApiProvider {
  Client client = Client();
  Future<List<Partita>> tutte(String? torneo) async {
    final supabase = Supabase.instance.client;
    try {
      final listaPartite;
      if (torneo != null && torneo.isNotEmpty) {
        listaPartite = await supabase
            .from('partita')
            .select()
            .match({'torneo': torneo}).order('data', ascending: false);
      } else {
        listaPartite = await supabase
            .from('partita')
            .select()
            .order('data', ascending: false);
      }
      final mapDone =
          listaPartite.map<Partita>((json) => Partita.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } catch (error) {
      throw Exception('Impossibile caricare le partite');
    }
  }

  Future<Partita> singola(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('partita')
          .select('*')
          .eq('id', id)
          .select()
          .single();
      return Partita.fromMap(response);
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.single', level: Level.SEVERE.value);
      throw Exception('Impossibile caricare la partita con id: $id');
    }
  }

  Future<Partita> crea(String squadra1, String squadra2, DateTime data,
      String descrizione, String torneo) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('partita')
          .insert({
            'squadraUno': squadra1,
            'squadraDue': squadra2,
            'marcatori': List.empty(),
            'ammoniti': List.empty(),
            'espulsi': List.empty(),
            'data': data.toIso8601String(),
            'descrizione': descrizione,
            'torneo': torneo
          })
          .select()
          .single();
      return Partita.fromMap(response);
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.create', level: Level.SEVERE.value);
      throw Exception('Impossibile creare la partita: error: ${e}');
    }
  }

  Future<bool> aggiorna(Partita partita) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('partita').update({
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
      }).eq('id', partita.id);
      return true;
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.update', level: Level.SEVERE.value);
      throw Exception('Impossibile aggiornare la partita');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('partita')
          .delete()
          .eq('id', id)
          .select()
          .single();
      final partitaEliminata = Partita.fromMap(response);
      QTLog.log('Partita rimossa', name: 'repositories.partita.delete');
      return true;
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.delete', level: Level.SEVERE.value);
      throw Exception('Impossibile eliminare la partita');
    }
  }
}
