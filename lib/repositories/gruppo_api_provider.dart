// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:quaderno_flutter/models/models.dart';

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
    } catch (e) {
      throw Exception('Impossibile caricare i gruppi: error: $e');
    }
  }

  Future<Gruppo> singolo(int id) async {
    QTLog.log('Get gruppo by id: $id', name: 'repositories.gruppo.single');
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('gruppo').select('*').eq('id', id).single();
      return Gruppo.fromMap(response);
    } catch (error) {
      QTLog.log(error.toString(), name: 'repositories.gruppo.single');
      throw Exception(
          'Impossibile caricare il gruppo con id: $id, error: $error');
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
    } catch (error) {
      QTLog.log(error.toString(),
          name: 'repositories.gruppo.getByNome', level: Level.SEVERE.value);
      throw Exception(
          'Impossibile caricare il gruppo con nome: $nome, error: $error');
    }
  }

  Future<Gruppo> crea(
      String nome, String girone, String logoPath, String torneo) async {
    final supabase = Supabase.instance.client;
    final logoFile = File(logoPath);
    try {
      final uploadResult = await supabase.storage.from('loghi').upload(
          'logo$nome${p.extension(logoPath)}', logoFile,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true));
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
    } catch (error) {
      QTLog.log('Impossibile creare il gruppo, errore: $error');
      throw Exception('Impossibile creare il gruppo');
    }
  }

  Future<bool> aggiorna(Gruppo gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('gruppo').update({
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
    } catch (error) {
      QTLog.log('Impossibile aggiornare il gruppo, errore: $error');
      throw Exception('Impossibile aggiornare il gruppo');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('gruppo').delete().eq('id', id).select().single();
      final gruppoEliminato = Gruppo.fromMap(response);
      QTLog.log('Gruppo rimosso', name: 'repositories.gruppo.delete');
      final deleteLogo = await supabase.storage.from('loghi').remove(
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
          final deletePhoto = await supabase.storage.from('giocatori').remove([
            '${giocatore.gruppo}${giocatore.nome}${p.extension(giocatore.photo!)}'
          ]);
          QTLog.log('Foto giocatore rimossa dal bucket',
              name: 'repositories.gruppo.delete');
        }
      }
      return true;
    } catch (error) {
      QTLog.log('Impossibile eliminare il gruppo, errore: $error');
      throw Exception('Impossibile eliminare il gruppo');
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
    } catch (error) {
      throw Exception('Impossibile aggiornare i gruppi');
    }
  }
}
