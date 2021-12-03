import 'dart:async';

import '../models/models.dart';
import 'admin_api_provider.dart';
import 'giocatore_api_provider.dart';
import 'gruppo_api_provider.dart';
import 'partita_api_provider.dart';

class Repository {
  final partitaApiProvider = PartitaApiProvider();
  final adminApiProvider = AdminApiProvider();
  final giocatoreApiProvider = GiocatoreApiProvider();
  final gruppoApiProvider = GruppoApiProvider();

  Future<List<PartitaModel>> listaPartite() => partitaApiProvider.tutte();
  Future<PartitaModel> creaPartita(
          String nomeSquadra1, String nomeSquadra2, DateTime dateTime) =>
      partitaApiProvider.crea(nomeSquadra1, nomeSquadra2, dateTime);
  Future<PartitaModel> singolaPartita(int id) => partitaApiProvider.singola(id);
  Future<bool> aggiornaPartita(PartitaModel partitaDaAggiornare) =>
      partitaApiProvider.aggiorna(partitaDaAggiornare);
  Future<bool> eliminaPartita(int id) => partitaApiProvider.elimina(id);
  Future<List<String>> giocatoriGruppo(String gruppo) =>
      giocatoreApiProvider.giocatoriByGruppo(gruppo);

  Future<bool> aggiornaClassifica() => adminApiProvider.aggiornaClassifica();
  Future<bool> resetClassifica() => adminApiProvider.resetClassifica();
  Future<List<Giocatore>> aggiornaMarcatori() =>
      adminApiProvider.aggiornaMarcatori();

  Future<List<Giocatore>> giocatori() => giocatoreApiProvider.tutti();
  Future<List<Giocatore>> filtroGruppo(String gruppo) async {
    final giocatori = await giocatoreApiProvider.tutti();
    final filtered =
        giocatori.where((giocatore) => giocatore.gruppo == gruppo).toList();
    return filtered;
  }

  Future<Giocatore> singoloGiocatore(int id) =>
      giocatoreApiProvider.singolo(id);
  Future<Giocatore> creaGiocatore(String nome, String gruppo, int immagine) =>
      giocatoreApiProvider.creaGiocatore(nome, gruppo, immagine);
  Future<bool> aggiornaGiocatore(Giocatore giocatoreDaAggiornare) =>
      giocatoreApiProvider.aggiorna(giocatoreDaAggiornare);
  Future<bool> eliminaGiocatore(int id) => giocatoreApiProvider.elimina(id);
  Future<List<Giocatore>> marcatori() => giocatoreApiProvider.marcatori();

  Future<List<Gruppo>> gruppi() => gruppoApiProvider.gruppi();
  Future<Gruppo> creaGruppo(String nome, String girone, String logo) =>
      gruppoApiProvider.crea(nome, girone, logo);
  Future<bool> aggiornaGruppo(Gruppo gruppo) =>
      gruppoApiProvider.aggiorna(gruppo);
  Future<bool> eliminaGruppo(int id) => gruppoApiProvider.elimina(id);
}
