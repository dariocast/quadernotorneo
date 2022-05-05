// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

class GiocatoreApiProvider {
  Future<List<String>> giocatoriByGruppo(String gruppo) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('giocatore')
        .select('nome')
        .eq('gruppo', gruppo)
        .execute();
    if (response.status == 200) {
      final listaNomi = response.data as List;
      final listaNomiSemplice =
          listaNomi.map<String>((entry) => entry['nome']).toList();
      return listaNomiSemplice;
    } else {
      throw Exception('Impossibile ottenere i giocatori');
    }
  }

  Future<List<Giocatore>> marcatori() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('giocatore')
        .select('*')
        .gt('gol', 0)
        .order('gol', ascending: false)
        .execute();
    if (response.status == 200) {
      final listaGiocatoriDB = response.data as List;
      final mapDone =
          listaGiocatoriDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      return mapDone.toList();
    } else {
      throw Exception('Impossibile ottenere i marcatori');
    }
  }

  Future<Giocatore> creaGiocatore(
      String nome, String gruppo, int immagine, String? photo) async {
    final supabase = Supabase.instance.client;
    String? publicURL = null;
    if (photo != null) {
      final logoFile = File(photo);
      final uploadResult = await supabase.storage.from('giocatori').upload(
          '$gruppo$nome${p.extension(photo)}', logoFile,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true));
      publicURL = supabase.storage
          .from('giocatori')
          .getPublicUrl('$gruppo$nome${p.extension(photo)}')
          .data;
    }
    final response = await supabase.from('giocatore').insert([
      {'nome': nome, 'gruppo': gruppo, 'image': immagine, 'photo': publicURL}
    ]).execute();
    if (response.error == null && response.data != null) {
      return Giocatore.fromMap(response.data[0]);
    } else {
      throw Exception('Impossibile creare nuovo giocatore');
    }
  }

  Future<bool> aggiorna(Giocatore giocatore, String? newPhoto) async {
    int random = Random().nextInt(100);
    final supabase = Supabase.instance.client;
    if (newPhoto != null) {
      if (giocatore.photo != null) {
        developer.log('Devo rimuovere la vecchia foto dal bucket',
            name: 'repositories.giocatore.update');
        final deletePhoto = await supabase.storage.from('giocatori').remove([
          '${giocatore.gruppo}${giocatore.nome}${p.extension(giocatore.photo!)}'
        ]);
        developer.log('Foto rimossa dal bucket',
            name: 'repositories.giocatore.update');
      }
      developer.log('Carico la nuova foto nel bucket',
          name: 'repositories.giocatore.update');
      final logoFile = File(newPhoto);
      final uploadResult = await supabase.storage.from('giocatori').upload(
          '${giocatore.gruppo}${giocatore.nome}${p.extension(newPhoto)}',
          logoFile,
          fileOptions: FileOptions(cacheControl: '3600', upsert: true));
      final publicURL = supabase.storage
          .from('giocatori')
          .getPublicUrl(
              '${giocatore.gruppo}${giocatore.nome}${p.extension(newPhoto)}')
          .data;
      developer.log('Foto caricata nel bucket',
          name: 'repositories.giocatore.delete');
      giocatore = giocatore.copyWith(photo: publicURL);
    }
    final response = await supabase
        .from('giocatore')
        .update({
          'nome': giocatore.nome,
          'image': giocatore.image,
          'gruppo': giocatore.gruppo,
          'gol': giocatore.gol,
          'ammonizioni': giocatore.ammonizioni,
          'espulsioni': giocatore.espulsioni,
          'photo': giocatore.photo,
        })
        .eq('id', giocatore.id)
        .execute();
    return response.error == null && response.data != null
        ? true
        : throw Exception('Impossibile aggiornare il giocatore');
  }

  Future<List<Giocatore>> aggiornaTutti(List<Giocatore> giocatori) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('giocatore')
        .upsert(giocatori.map((e) => e.toMap()).toList())
        .execute();
    if (response.error == null && response.data != null) {
      final listaGiocatoriDB = response.data as List;
      final mapDone =
          listaGiocatoriDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      final lista = mapDone.toList();
      lista.sort((a, b) => b.gol.compareTo(a.gol));
      return lista;
    } else {
      throw Exception('Impossibile aggiornare i giocatori');
    }
  }

  Future<bool> elimina(int id) async {
    // final supabase = Supabase.instance.client;
    // final response =
    //     await supabase.from('giocatore').delete().eq('id', id).execute();
    // return response.status == 200;

    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('giocatore').delete().eq('id', id).execute();
    final giocatoreEliminato = Giocatore.fromMap(response.data[0]);
    developer.log('Giocatore rimosso', name: 'repositories.giocatore.delete');
    if (giocatoreEliminato.photo != null) {
      final deletePhoto = await supabase.storage.from('giocatori').remove([
        '${giocatoreEliminato.gruppo}${giocatoreEliminato.nome}${p.extension(giocatoreEliminato.photo!)}'
      ]);
      developer.log('Foto rimossa dal bucket',
          name: 'repositories.giocatore.delete');
    }

    return response.status == 200
        ? true
        : throw Exception('Impossibile eliminare il gruppo');
  }

  Future<List<Giocatore>> tutti() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('giocatore').select('*').execute();
    final error = response.error;
    if (response.status == 200 && error == null) {
      final listaGruppiDB = response.data as List;
      final mapDone =
          listaGruppiDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } else {
      throw Exception('Impossibile caricare i giocatori');
    }
  }

  Future<Giocatore> singolo(String nome, String gruppo) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('giocatore')
        .select('*')
        .eq('nome', nome)
        .eq('gruppo', gruppo)
        .execute();
    final error = response.error;
    if (response.status != 200 && error != null) {
      throw Exception('Impossibile caricare $nome gruppo $gruppo');
    } else {
      return Giocatore.fromMap(response.data[0]);
    }
  }
}
