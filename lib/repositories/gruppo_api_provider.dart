// ignore_for_file: unused_local_variable

import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:quaderno_flutter/models/models.dart';

class GruppoApiProvider {
  Client client = Client();
  Future<List<Gruppo>> gruppi() async {
    // final response = await client.get(Uri.parse('$gruppiUrl/getAll.php'));
    final supabase = Supabase.instance.client;
    final response = await supabase.from('gruppo').select('*').execute();
    final error = response.error;
    if (response.status == 200 && response.data != null) {
      final listaGruppiDB = response.data as List;
      final mapDone = listaGruppiDB.map<Gruppo>((json) => Gruppo.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } else {
      throw Exception('Impossibile caricare le i gruppi: error: $error');
    }
  }

  Future<Gruppo> singolo(int id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('gruppo').select('*').eq('id', id).execute();
    final error = response.error;
    if (response.status == 200 && response.data != null) {
      return Gruppo.fromMap(response.data[0]);
    } else {
      throw Exception(
          'Impossibile caricare il gruppo con id: $id, error: $error');
    }
  }

  Future<Gruppo> getByNome(String nome) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('gruppo').select('*').eq('nome', nome).execute();
    final error = response.error;
    if (response.status == 200 && response.data != null) {
      return Gruppo.fromMap(response.data[0]);
    } else {
      throw Exception(
          'Impossibile caricare il gruppo con nome: $nome, error: $error');
    }
  }

  Future<Gruppo> crea(String nome, String girone, String logoPath) async {
    final supabase = Supabase.instance.client;
    final logoFile = File(logoPath);
    final uploadResult = await supabase.storage.from('loghi').upload(
        'logo$nome${p.extension(logoPath)}', logoFile,
        fileOptions: FileOptions(cacheControl: '3600', upsert: true));
    final publicURL = supabase.storage
        .from('loghi')
        .getPublicUrl('logo$nome${p.extension(logoPath)}')
        .data;
    final response = await supabase.from('gruppo').insert([
      {'nome': nome, 'girone': girone, 'logo': publicURL}
    ]).execute();
    final error = response.error;
    if (error != null && response.status != 200) {
      throw Exception('Impossibile creare il gruppo');
    } else {
      return Gruppo.fromMap(response.data[0]);
    }
  }

  Future<bool> aggiorna(Gruppo gruppo) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('gruppo')
        .update({
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
        })
        .eq('id', gruppo.id)
        .execute();
    return response.status == 200
        ? true
        : throw Exception('Impossibile aggiornare il gruppo');
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('gruppo').delete().eq('id', id).execute();
    final gruppoEliminato = Gruppo.fromMap(response.data[0]);
    developer.log('Gruppo rimosso', name: 'repositories.gruppo.delete');
    final deleteLogo = await supabase.storage.from('loghi').remove(
        ['logo${gruppoEliminato.nome}${p.extension(gruppoEliminato.logo)}']);
    developer.log('Logo rimosso dal bucket',
        name: 'repositories.gruppo.delete');

    final resDeletedPlayers = await supabase
        .from('giocatore')
        .delete()
        .match({'gruppo': gruppoEliminato.nome}).execute();

    developer.log('Giocatori rimossi', name: 'repositories.gruppo.delete');
    for (var giocatoreMap in resDeletedPlayers.data) {
      final giocatore = Giocatore.fromMap(giocatoreMap);
      if (giocatore.photo != null) {
        final deletePhoto = await supabase.storage.from('giocatori').remove([
          '${giocatore.gruppo}${giocatore.nome}${p.extension(giocatore.photo!)}'
        ]);
        developer.log('Foto giocatore rimossa dal bucket',
            name: 'repositories.gruppo.delete');
      }
    }
    return response.status == 200 && resDeletedPlayers.status == 200
        ? true
        : throw Exception('Impossibile eliminare il gruppo');
  }

  Future<List<Gruppo>> aggiornaTutti(List<Gruppo> gruppi) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('gruppo')
        .upsert(gruppi.map((e) => e.toMap()).toList())
        .execute();
    if (response.error == null && response.data != null) {
      final gruppiDB = response.data as List;
      final mapDone = gruppiDB.map<Gruppo>((json) => Gruppo.fromMap(json));
      final lista = mapDone.toList();
      lista.sort((a, b) => b.pt.compareTo(a.pt));
      return lista;
    } else {
      throw Exception('Impossibile aggiornare i gruppi');
    }
  }
}
