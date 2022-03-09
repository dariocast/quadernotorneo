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
          'gruppo': giocatore.gruppo,
          'gol': giocatore.gol,
          'ammonizioni': giocatore.ammonizioni,
          'espulsioni': giocatore.espulsioni,
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
