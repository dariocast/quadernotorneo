import 'dart:convert';

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
      return response.data;
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
      String nome, String gruppo, int immagine) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('giocatore').insert([
      {'nome': nome, 'gruppo': gruppo, 'image': immagine}
    ]).execute();
    if (response.error == null && response.data != null) {
      return Giocatore.fromMap(response.data[0]);
    } else {
      throw Exception('Impossibile creare nuovo giocatore');
    }
  }

  Future<bool> aggiorna(Giocatore giocatore) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('giocatore')
        .update({
          'nome': giocatore.nome,
          'image': giocatore.image,
        })
        .eq('id', giocatore.id)
        .execute();
    return response.status == 200
        ? true
        : throw Exception('Impossibile aggiornare il giocatore');
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('giocatore').delete().eq('id', id).execute();
    return response.status == 200;
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

  Future<Giocatore> singolo(int id) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('giocatore').select('*').eq('id', id).execute();
    final error = response.error;
    if (response.status == 200 && error == null) {
      return Giocatore.fromMap(response.data[0]);
    } else {
      throw Exception('Impossibile caricare il giocatore con id: $id');
    }
  }
}
