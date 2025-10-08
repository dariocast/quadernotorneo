// ignore_for_file: unused_local_variable

import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/errors.dart';
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
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile caricare i tornei: ${error.message}',
          name: 'TorneoApiProvider.tutti');
      throw DatabaseError('Impossibile caricare i tornei: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile caricare i tornei, errore: $error',
          name: 'TorneoApiProvider.tutti');
      throw AppError('Errore imprevisto durante il caricamento dei tornei.');
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
    } on PostgrestException catch (e) {
      QTLog.log(
          'Impossibile caricare il torneo con id: $id, errore: ${e.message}',
          name: 'repositories.torneo.single',
          level: Level.SEVERE.value);
      throw DatabaseError(
          'Impossibile caricare il torneo con id: $id, errore: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.single', level: Level.SEVERE.value);
      throw AppError('Impossibile caricare il torneo con id: $id');
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
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile creare il torneo: ${e.message}',
          name: 'repositories.torneo.create', level: Level.SEVERE.value);
      throw DatabaseError('Impossibile creare il torneo: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.create', level: Level.SEVERE.value);
      throw AppError('Impossibile creare il torneo: error: $e');
    }
  }

  Future<bool> aggiorna(Torneo torneo) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from(TORNEI_TABLE).update({
        'name': torneo.name,
      }).eq('id', torneo.id);
      return true;
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile aggiornare il torneo: ${e.message}',
          name: 'repositories.torneo.update', level: Level.SEVERE.value);
      throw DatabaseError('Impossibile aggiornare il torneo: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.update', level: Level.SEVERE.value);
      throw AppError('Impossibile aggiornare il torneo');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from(TORNEI_TABLE).delete().eq('id', id).select().single();
      QTLog.log('Torneo rimosso', name: 'repositories.torneo.delete');
      return true;
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile eliminare il torneo: ${e.message}',
          name: 'repositories.torneo.delete', level: Level.SEVERE.value);
      throw DatabaseError('Impossibile eliminare il torneo: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.torneo.delete', level: Level.SEVERE.value);
      throw AppError('Impossibile eliminare il torneo');
    }
  }
}
