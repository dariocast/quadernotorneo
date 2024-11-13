// ignore_for_file: unused_local_variable

import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/log_helper.dart';

const String TORNEI_TABLE = 'tournament';

class TorneoApiProvider {
  Client client = Client();
  Future<List<Torneo>> tutti() async {
    final supabase = Supabase.instance.client;
    try {
      final List listaTornei;
      listaTornei = await supabase.from(TORNEI_TABLE).select();

      final mapDone = listaTornei.map<Torneo>((json) => Torneo.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } catch (error) {
      throw Exception('Impossibile caricare i tornei');
    }
  }

  Future<Torneo> singolo(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from(TORNEI_TABLE)
          .select('*')
          .eq('id', id)
          .select()
          .single();
      return Torneo.fromMap(response);
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.single', level: Level.SEVERE.value);
      throw Exception('Impossibile caricare il torneo con id: $id');
    }
  }

  Future<Torneo> crea(String name) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from(TORNEI_TABLE)
          .insert({
            'name': name,
          })
          .select()
          .single();
      return Torneo.fromMap(response);
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.create', level: Level.SEVERE.value);
      throw Exception('Impossibile creare il torneo: error: $e');
    }
  }

  Future<bool> aggiorna(Torneo torneo) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from(TORNEI_TABLE).update({
        'name': torneo.name,
      }).eq('id', torneo.id);
      return true;
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.update', level: Level.SEVERE.value);
      throw Exception('Impossibile aggiornare il torneo');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from(TORNEI_TABLE)
          .delete()
          .eq('id', id)
          .select()
          .single();
      final torneoEliminato = Torneo.fromMap(response);
      QTLog.log('Torneo rimossa', name: 'repositories.torneo.delete');
      return true;
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.delete', level: Level.SEVERE.value);
      throw Exception('Impossibile eliminare il torneo');
    }
  }
}
