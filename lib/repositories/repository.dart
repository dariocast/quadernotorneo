import 'dart:async';

import '../models/models.dart';
import 'giocatore_api_provider.dart';
import 'gruppo_api_provider.dart';
import 'partita_api_provider.dart';

class Repository {
  final partitaApiProvider = PartitaApiProvider();
  final giocatoreApiProvider = GiocatoreApiProvider();
  final gruppoApiProvider = GruppoApiProvider();

  Future<List<Partita>> listaPartite() => partitaApiProvider.tutte();
  Future<Partita> creaPartita(String nomeSquadra1, String nomeSquadra2,
          DateTime dateTime, String descrizione) =>
      partitaApiProvider.crea(
          nomeSquadra1, nomeSquadra2, dateTime, descrizione);
  Future<Partita> singolaPartita(int id) => partitaApiProvider.singola(id);
  Future<bool> aggiornaPartita(Partita partitaDaAggiornare) =>
      partitaApiProvider.aggiorna(partitaDaAggiornare);
  Future<bool> eliminaPartita(int id) => partitaApiProvider.elimina(id);
  Future<List<String>> giocatoriGruppo(String gruppo) =>
      giocatoreApiProvider.giocatoriByGruppo(gruppo);

  Future<List<Giocatore>> giocatori() => giocatoreApiProvider.tutti();
  Future<List<Giocatore>> filtroGruppo(String gruppo) async {
    final giocatori = await giocatoreApiProvider.tutti();
    final filtered =
        giocatori.where((giocatore) => giocatore.gruppo == gruppo).toList();
    return filtered;
  }

  // Future<Giocatore> singoloGiocatore(int id) => giocatoreApiProvider.singolo(id);
  Future<Giocatore> creaGiocatore(
          String nome, String gruppo, int immagine, String? photo) =>
      giocatoreApiProvider.creaGiocatore(nome, gruppo, immagine, photo);
  Future<bool> aggiornaGiocatore(Giocatore giocatoreDaAggiornare, newPhoto) =>
      giocatoreApiProvider.aggiorna(giocatoreDaAggiornare, newPhoto);
  Future<bool> eliminaGiocatore(int id) => giocatoreApiProvider.elimina(id);
  Future<List<Giocatore>> marcatori() => giocatoreApiProvider.marcatori();
  Future<List<Giocatore>> aggiornaMarcatori() async {
    List<Partita> partite = await partitaApiProvider.tutte();
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
  Future<List<Gruppo>> aggiornaStatistiche({bool reset = false}) async {
    List<Partita> partite = await partitaApiProvider.tutte();
    List<Gruppo> gruppi = await gruppoApiProvider.gruppi();

    gruppi = gruppi
        .map((e) => e.copyWith(
              pg: 0,
              v: 0,
              p: 0,
              s: 0,
              gf: 0,
              gs: 0,
              pt: 0,
            ))
        .toList();

    if (reset) {
      return gruppoApiProvider.aggiornaTutti(gruppi);
    }

    for (var partita in partite) {
      int pg1 = 0, gf1 = 0, gs1 = 0, pt1 = 0, v1 = 0, p1 = 0, s1 = 0;
      int pg2 = 0, gf2 = 0, gs2 = 0, pt2 = 0, v2 = 0, p2 = 0, s2 = 0;

      int gruppo1Index = gruppi.indexWhere(
        (element) => element.nome == partita.squadraUno,
      );
      int gruppo2Index = gruppi.indexWhere(
        (element) => element.nome == partita.squadraDue,
      );

      pg1 = gruppi[gruppo1Index].pg + 1;
      pg2 = gruppi[gruppo2Index].pg + 1;

      gf1 = gs2 = gruppi[gruppo1Index].gf + partita.golSquadraUno;
      gf2 = gs1 = gruppi[gruppo1Index].gs + partita.golSquadraDue;

      if (partita.golSquadraUno > partita.golSquadraDue) {
        v1 = gruppi[gruppo1Index].v + 1;
        pt1 = gruppi[gruppo1Index].pt + 3;

        s2 = gruppi[gruppo2Index].s + 1;
      } else if (partita.golSquadraUno == partita.golSquadraDue) {
        p1 = gruppi[gruppo1Index].p + 1;
        p2 = gruppi[gruppo2Index].p + 1;
        pt1 = gruppi[gruppo1Index].pt + 1;
        pt2 = gruppi[gruppo2Index].pt + 1;
      } else {
        v2 = gruppi[gruppo2Index].v + 1;
        pt2 = gruppi[gruppo2Index].pt + 3;

        s1 = gruppi[gruppo2Index].s + 1;
      }

      Gruppo aggiornato = gruppi[gruppo1Index].copyWith(
        pg: pg1,
        v: v1,
        p: p1,
        s: s1,
        gf: gf1,
        gs: gs1,
        pt: pt1,
      );
      gruppi.replaceRange(gruppo1Index, gruppo1Index + 1, [aggiornato]);

      aggiornato = gruppi[gruppo2Index].copyWith(
        pg: pg2,
        v: v2,
        p: p2,
        s: s2,
        gf: gf2,
        gs: gs2,
        pt: pt2,
      );
      gruppi.replaceRange(gruppo2Index, gruppo2Index + 1, [aggiornato]);
    }
    return gruppoApiProvider.aggiornaTutti(gruppi);
  }
}
