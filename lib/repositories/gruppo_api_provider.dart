// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/utils/errors.dart';

import '../utils/log_helper.dart';

class GruppoApiProvider {
  Client client = Client();
  Future<List<Gruppo>> gruppi(String? torneo) async {
    QTLog.log('Getting All teams', name: 'repositories.gruppo.all');
    final supabase = Supabase.instance.client;
    try {
      final listaGruppi = supabase.from('gruppo').select('*');
      late List listaGruppiTorneo;
      if (torneo != null) {
        listaGruppiTorneo = await listaGruppi.eq('torneo', torneo);
      } else {
        listaGruppiTorneo = await listaGruppi;
      }
      final mapDone =
          listaGruppiTorneo.map<Gruppo>((json) => Gruppo.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } on PostgrestException catch (e) {
      QTLog.log('Impossibile caricare i gruppi: ${e.message}',
          name: 'GruppoApiProvider.gruppi');
      throw DatabaseError('Impossibile caricare i gruppi: ${e.message}');
    } catch (e) {
      QTLog.log('Impossibile caricare i gruppi: error: $e',
          name: 'GruppoApiProvider.gruppi');
      throw AppError('Errore imprevisto durante il caricamento dei gruppi.');
    }
  }

  Future<Gruppo> singolo(int id) async {
    QTLog.log('Get gruppo by id: $id', name: 'repositories.gruppo.single');
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('gruppo').select('*').eq('id', id).single();
      return Gruppo.fromMap(response);
    } on PostgrestException catch (error) {
      QTLog.log(
          'Impossibile caricare il gruppo con id: $id, error: ${error.message}',
          name: 'repositories.gruppo.single');
      throw DatabaseError(
          'Impossibile caricare il gruppo con id: $id, error: ${error.message}');
    } catch (error) {
      QTLog.log(error.toString(), name: 'repositories.gruppo.single');
      throw AppError('Impossibile caricare il gruppo con id: $id');
    }
  }

  Future<Gruppo> getByNome(String nome) async {
    QTLog.log('Get gruppo by nome: $nome',
        name: 'repositories.gruppo.getByNome');
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('gruppo').select('*').eq('nome', nome).single();
      return Gruppo.fromMap(response);
    } on PostgrestException catch (error) {
      QTLog.log(
          'Impossibile caricare il gruppo con nome: $nome, error: ${error.message}',
          name: 'repositories.gruppo.getByNome',
          level: Level.SEVERE.value);
      throw DatabaseError(
          'Impossibile caricare il gruppo con nome: $nome, error: ${error.message}');
    } catch (error) {
      QTLog.log(error.toString(),
          name: 'repositories.gruppo.getByNome', level: Level.SEVERE.value);
      throw AppError('Impossibile caricare il gruppo con nome: $nome');
    }
  }

  Future<Gruppo> crea(
      String nome, String girone, String logoPath, String torneo) async {
    final supabase = Supabase.instance.client;
    final logoFile = File(logoPath);
    try {
      final uploadResult = await supabase.storage.from('loghi').upload(
          'logo$nome${p.extension(logoPath)}', logoFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true));
      final publicURL = supabase.storage
          .from('loghi')
          .getPublicUrl('logo$nome${p.extension(logoPath)}');
      final response = await supabase
          .from('gruppo')
          .insert([
            {
              'nome': nome,
              'girone': girone,
              'logo': publicURL,
              'torneo': torneo
            }
          ])
          .select()
          .single();
      return Gruppo.fromMap(response);
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile creare il gruppo: ${error.message}',
          name: 'GruppoApiProvider.crea');
      throw DatabaseError('Impossibile creare il gruppo: ${error.message}');
    } on StorageException catch (error) {
      QTLog.log('Impossibile caricare il logo: ${error.message}',
          name: 'GruppoApiProvider.crea');
      throw NetworkError('Impossibile caricare il logo: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile creare il gruppo, errore: $error',
          name: 'GruppoApiProvider.crea');
      throw AppError('Errore imprevisto durante la creazione del gruppo.');
    }
  }

  Future<bool> aggiorna(Gruppo gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('gruppo').update({
        'nome': gruppo.nome,
        'girone': gruppo.girone,
        'logo': gruppo.logo,
        'pg': gruppo.pg,
        'v': gruppo.v,
        'p': gruppo.p,
        's': gruppo.s,
        'gf': gruppo.gf,
        'gs': gruppo.gs,
        'pt': gruppo.pt
      }).eq('id', gruppo.id);
      return true;
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile aggiornare il gruppo: ${error.message}',
          name: 'GruppoApiProvider.aggiorna');
      throw DatabaseError('Impossibile aggiornare il gruppo: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile aggiornare il gruppo, errore: $error',
          name: 'GruppoApiProvider.aggiorna');
      throw AppError('Errore imprevisto durante l\'aggiornamento del gruppo.');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('gruppo').delete().eq('id', id).select().single();
      final gruppoEliminato = Gruppo.fromMap(response);
      QTLog.log('Gruppo rimosso', name: 'repositories.gruppo.delete');
      await supabase.storage.from('loghi').remove(
          ['logo${gruppoEliminato.nome}${p.extension(gruppoEliminato.logo)}']);
      QTLog.log('Logo rimosso dal bucket', name: 'repositories.gruppo.delete');

      final resDeletedPlayers = await supabase
          .from('giocatore')
          .delete()
          .match({'gruppo': gruppoEliminato.nome}).select();

      QTLog.log('Giocatori rimossi', name: 'repositories.gruppo.delete');
      for (var giocatoreMap in resDeletedPlayers) {
        final giocatore = Giocatore.fromMap(giocatoreMap);
        if (giocatore.photo != null) {
          await supabase.storage.from('giocatori').remove([
            '${giocatore.gruppo}${giocatore.nome}${p.extension(giocatore.photo!)}'
          ]);
          QTLog.log('Foto giocatore rimossa dal bucket',
              name: 'repositories.gruppo.delete');
        }
      }
      return true;
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile eliminare il gruppo: ${error.message}',
          name: 'repositories.gruppo.delete');
      throw DatabaseError('Impossibile eliminare il gruppo: ${error.message}');
    } on StorageException catch (error) {
      QTLog.log(
          'Impossibile eliminare il logo o la foto del giocatore: ${error.message}',
          name: 'repositories.gruppo.delete');
      throw NetworkError(
          'Impossibile eliminare il logo o la foto del giocatore: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile eliminare il gruppo, errore: $error',
          name: 'repositories.gruppo.delete');
      throw AppError('Errore imprevisto durante l\'eliminazione del gruppo.');
    }
  }

  Future<List<Gruppo>> aggiornaTutti(List<Gruppo> gruppi) async {
    final supabase = Supabase.instance.client;
    try {
      final gruppiDB = await supabase
          .from('gruppo')
          .upsert(gruppi.map((e) => e.toMap()).toList())
          .select();
      final mapDone = gruppiDB.map<Gruppo>((json) => Gruppo.fromMap(json));
      final List<Gruppo> lista = mapDone.toList();
      lista.sort((a, b) => b.pt.compareTo(a.pt));
      return lista;
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile aggiornare i gruppi: ${error.message}',
          name: 'GruppoApiProvider.aggiornaTutti');
      throw DatabaseError('Impossibile aggiornare i gruppi: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile aggiornare i gruppi, errore: $error',
          name: 'GruppoApiProvider.aggiornaTutti');
      throw AppError('Errore imprevisto durante l\'aggiornamento dei gruppi.');
    }
  }
}
