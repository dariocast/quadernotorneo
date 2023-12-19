// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/log_helper.dart';

class GiocatoreApiProvider {
  Future<List<String>> giocatoriByGruppo(String gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final listaNomi = await supabase
          .from('giocatore')
          .select('nome')
          .eq('gruppo', gruppo) as List;
      final listaNomiSemplice =
          listaNomi.map<String>((entry) => entry['nome']).toList();
      return listaNomiSemplice;
    } catch (error) {
      QTLog.log('Impossibile ottenere i giocatori, errore: $error');
      throw Exception('Impossibile ottenere i giocatori');
    }
  }

  Future<List<Giocatore>> marcatori(String? gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final listaGiocatoriDB = await supabase
          .from('giocatore')
          .select('*')
          .eq('gruppo', gruppo)
          .gt('gol', 0)
          .order('gol', ascending: false);
      final mapDone =
          listaGiocatoriDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      return mapDone.toList();
    } catch (error) {
      QTLog.log('Impossibile ottenere i marcatori, errore: $error');
      throw Exception('Impossibile ottenere i marcatori');
    }
  }

  Future<Giocatore> creaGiocatore(
      String nome, String gruppo, int immagine, String? photo) async {
    final supabase = Supabase.instance.client;
    try {
      String? publicURL = null;
      if (photo != null) {
        final logoFile = File(photo);
        final uploadResult = await supabase.storage.from('giocatori').upload(
            '$gruppo$nome${p.extension(photo)}', logoFile,
            fileOptions: FileOptions(cacheControl: '3600', upsert: true));
        publicURL = supabase.storage
            .from('giocatori')
            .getPublicUrl('$gruppo$nome${p.extension(photo)}');
      }
      final response = await supabase
          .from('giocatore')
          .insert([
            {
              'nome': nome,
              'gruppo': gruppo,
              'image': immagine,
              'photo': publicURL
            }
          ])
          .select()
          .single();
      return Giocatore.fromMap(response);
    } catch (error) {
      throw Exception('Impossibile creare nuovo giocatore');
    }
  }

  Future<bool> aggiorna(Giocatore giocatore, String? newPhoto) async {
    int random = Random().nextInt(100);
    final supabase = Supabase.instance.client;
    try {
      if (newPhoto != null) {
        if (giocatore.photo != null) {
          QTLog.log('Devo rimuovere la vecchia foto dal bucket',
              name: 'repositories.giocatore.update');
          final deletePhoto = await supabase.storage.from('giocatori').remove([
            '${giocatore.gruppo}${giocatore.nome}${p.extension(giocatore.photo!)}'
          ]);
          QTLog.log('Foto rimossa dal bucket',
              name: 'repositories.giocatore.update');
        }
        QTLog.log('Carico la nuova foto nel bucket',
            name: 'repositories.giocatore.update');
        final logoFile = File(newPhoto);
        final uploadResult = await supabase.storage.from('giocatori').upload(
            '${giocatore.gruppo}${giocatore.nome}${p.extension(newPhoto)}',
            logoFile,
            fileOptions: FileOptions(cacheControl: '3600', upsert: true));
        final publicURL = supabase.storage.from('giocatori').getPublicUrl(
            '${giocatore.gruppo}${giocatore.nome}${p.extension(newPhoto)}');
        QTLog.log('Foto caricata nel bucket',
            name: 'repositories.giocatore.update');
        giocatore = giocatore.copyWith(photo: publicURL);
      }
      final response = await supabase.from('giocatore').update({
        'nome': giocatore.nome,
        'image': giocatore.image,
        'gruppo': giocatore.gruppo,
        'gol': giocatore.gol,
        'ammonizioni': giocatore.ammonizioni,
        'espulsioni': giocatore.espulsioni,
        'photo': giocatore.photo,
      }).eq('id', giocatore.id);
      return true;
    } catch (error) {
      QTLog.log('Errore durante l\'aggiornamento: $error',
          name: 'repositories.giocatore.update', level: Level.SEVERE.value);
      throw Exception('Impossibile aggiornare il giocatore');
    }
  }

  Future<List<Giocatore>> aggiornaTutti(List<Giocatore> giocatori) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('giocatore')
          .upsert(giocatori.map((e) => e.toMap()).toList())
          .select();
      final mapDone =
          response.map<Giocatore>((json) => Giocatore.fromMap(json));
      final List<Giocatore> lista = mapDone.toList();
      lista.sort((a, b) => b.gol.compareTo(a.gol));
      return lista;
    } catch (error) {
      QTLog.log('Errore nell\'aggiornamento dei marcatori: $error');
      throw Exception('Impossibile aggiornare i giocatori');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('giocatore')
          .delete()
          .eq('id', id)
          .select()
          .single();
      final giocatoreEliminato = Giocatore.fromMap(response);
      QTLog.log('Giocatore rimosso', name: 'repositories.giocatore.delete');
      if (giocatoreEliminato.photo != null) {
        final deletePhoto = await supabase.storage.from('giocatori').remove([
          '${giocatoreEliminato.gruppo}${giocatoreEliminato.nome}${p.extension(giocatoreEliminato.photo!)}'
        ]);
        QTLog.log('Foto rimossa dal bucket',
            name: 'repositories.giocatore.delete');
      }

      return true;
    } catch (error) {
      throw Exception('Impossibile eliminare il gruppo');
    }
  }

  Future<List<Giocatore>> tutti() async {
    final supabase = Supabase.instance.client;
    try {
      final listaGruppiDB = await supabase.from('giocatore').select('*');
      final mapDone =
          listaGruppiDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } catch (error) {
      throw Exception('Impossibile caricare i giocatori');
    }
  }

  Future<Giocatore> singolo(String nome, String gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('giocatore')
          .select('*')
          .eq('nome', nome)
          .eq('gruppo', gruppo)
          .select()
          .single();
      return Giocatore.fromMap(response);
    } catch (error) {
      throw Exception('Impossibile caricare $nome gruppo $gruppo');
    }
  }
}
