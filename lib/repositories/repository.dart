import 'dart:async';
import 'package:quaderno_flutter/models/models.dart';
import 'partita_api_provider.dart';

class Repository {
  final partitaApiProvider = PartitaApiProvider();

  Future<List<PartitaModel>> listaPartite() => partitaApiProvider.tutte();
  Future<PartitaModel> creaPartita(
          String nomeSquadra1, String nomeSquadra2, DateTime dateTime) =>
      partitaApiProvider.crea(nomeSquadra1, nomeSquadra2, dateTime);
  Future<PartitaModel> singolaPartita(int id) => partitaApiProvider.singola(id);
  Future<bool> aggiornaPartita(PartitaModel partitaDaAggiornare) =>
      partitaApiProvider.aggiorna(partitaDaAggiornare);
  Future<bool> eliminaPartita(int id) => partitaApiProvider.elimina(id);
  Future<List<String>> giocatoriGruppo(String gruppo) =>
      partitaApiProvider.giocatoriByGruppo(gruppo);
  Future<List<Gruppo>> gruppi() => partitaApiProvider.gruppi();
}
