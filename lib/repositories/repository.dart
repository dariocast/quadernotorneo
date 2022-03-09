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
  Future<List<Giocatore>> aggiornaMarcatoriOld() =>
      adminApiProvider.aggiornaMarcatori();

  Future<List<Giocatore>> giocatori() => giocatoreApiProvider.tutti();
  Future<List<Giocatore>> filtroGruppo(String gruppo) async {
    final giocatori = await giocatoreApiProvider.tutti();
    final filtered =
        giocatori.where((giocatore) => giocatore.gruppo == gruppo).toList();
    return filtered;
  }

  // Future<Giocatore> singoloGiocatore(int id) => giocatoreApiProvider.singolo(id);
  Future<Giocatore> creaGiocatore(String nome, String gruppo, int immagine) =>
      giocatoreApiProvider.creaGiocatore(nome, gruppo, immagine);
  Future<bool> aggiornaGiocatore(Giocatore giocatoreDaAggiornare) =>
      giocatoreApiProvider.aggiorna(giocatoreDaAggiornare);
  Future<bool> eliminaGiocatore(int id) => giocatoreApiProvider.elimina(id);
  Future<List<Giocatore>> marcatori() => giocatoreApiProvider.marcatori();
  Future<List<Giocatore>> aggiornaMarcatori() async {
    List<PartitaModel> partite = await partitaApiProvider.tutte();
    List<Giocatore> giocatori = await giocatoreApiProvider.tutti();

    giocatori = giocatori
        .map((e) => e.copyWith(gol: 0, ammonizioni: 0, espulsioni: 0))
        .toList();

    for (var partita in partite) {
      // aggiornamento gol
      for (var marcatore in partita.marcatori) {
        if (!marcatore.nome.contains('(Aut)')) {
          int giocatoreIndex = giocatori.indexWhere(
            (element) =>
                element.nome == marcatore.nome &&
                element.gruppo == marcatore.gruppo,
          );
          Giocatore aggiornato = giocatori[giocatoreIndex]
              .copyWith(gol: giocatori[giocatoreIndex].gol + 1);
          giocatori
              .replaceRange(giocatoreIndex, giocatoreIndex + 1, [aggiornato]);
        }
      }
      // aggiornamento ammonizioni
      for (var ammonito in partita.ammoniti) {
        int giocatoreIndex = giocatori.indexWhere(
          (element) =>
              element.nome == ammonito.nome &&
              element.gruppo == ammonito.gruppo,
        );
        Giocatore aggiornato = giocatori[giocatoreIndex]
            .copyWith(ammonizioni: giocatori[giocatoreIndex].ammonizioni + 1);
        giocatori
            .replaceRange(giocatoreIndex, giocatoreIndex + 1, [aggiornato]);
      }
      // aggiornamento espulsioni
      for (var espulso in partita.espulsi) {
        int giocatoreIndex = giocatori.indexWhere(
          (element) =>
              element.nome == espulso.nome && element.gruppo == espulso.gruppo,
        );
        Giocatore aggiornato = giocatori[giocatoreIndex]
            .copyWith(espulsioni: giocatori[giocatoreIndex].espulsioni + 1);
        giocatori
            .replaceRange(giocatoreIndex, giocatoreIndex + 1, [aggiornato]);
      }
    }
    return giocatoreApiProvider.aggiornaTutti(giocatori);
    // return giocatoreApiProvider.marcatori();
  }

  Future<List<Gruppo>> gruppi() => gruppoApiProvider.gruppi();
  Future<Gruppo> creaGruppo(String nome, String girone, String logo) =>
      gruppoApiProvider.crea(nome, girone, logo);
  Future<bool> aggiornaGruppo(Gruppo gruppo) =>
      gruppoApiProvider.aggiorna(gruppo);
  Future<bool> eliminaGruppo(int id) => gruppoApiProvider.elimina(id);
}
