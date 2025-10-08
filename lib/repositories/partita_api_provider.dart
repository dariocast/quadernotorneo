// ignore_for_file: unused_local_variable

import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/errors.dart';
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
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile caricare le partite: ${error.message}',
          name: 'PartitaApiProvider.tutte');
      throw DatabaseError('Impossibile caricare le partite: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile caricare le partite, errore: $error',
          name: 'PartitaApiProvider.tutte');
      throw AppError('Errore imprevisto durante il caricamento delle partite.');
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
    } on PostgrestException catch (e) {
      QTLog.log(
          'Impossibile caricare la partita con id: $id, errore: ${e.message}',
          name: 'repositories.partita.single',
          level: Level.SEVERE.value);
      throw DatabaseError(
          'Impossibile caricare la partita con id: $id, errore: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.single', level: Level.SEVERE.value);
      throw AppError('Impossibile caricare la partita con id: $id');
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
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile creare la partita: ${e.message}',
          name: 'repositories.partita.create', level: Level.SEVERE.value);
      throw DatabaseError('Impossibile creare la partita: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.create', level: Level.SEVERE.value);
      throw AppError('Impossibile creare la partita: error: $e');
    }
  }

  Future<bool> aggiorna(Partita partita) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('partita').update({
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
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile aggiornare la partita: ${e.message}',
          name: 'repositories.partita.update', level: Level.SEVERE.value);
      throw DatabaseError('Impossibile aggiornare la partita: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.update', level: Level.SEVERE.value);
      throw AppError('Impossibile aggiornare la partita');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('partita').delete().eq('id', id).select().single();
      QTLog.log('Partita rimossa', name: 'repositories.partita.delete');
      return true;
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile eliminare la partita: ${e.message}',
          name: 'repositories.partita.delete', level: Level.SEVERE.value);
      throw DatabaseError('Impossibile eliminare la partita: ${e.message}');
    } catch (e) {
      QTLog.log(e.toString(),
          name: 'repositories.partita.delete', level: Level.SEVERE.value);
      throw AppError('Impossibile eliminare la partita');
    }
  }
}
