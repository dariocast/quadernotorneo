import 'dart:async';
import 'package:quaderno_flutter/src/models/models.dart';

import 'gruppo_api_provider.dart';
import 'partita_api_provider.dart';
import '../models/gruppo_model.dart';

class Repository {
  final gruppoApiProvider = GruppoApiProvider();
  final partitaApiProvider = PartitaApiProvider();

  Future<List<PartitaModel>> listaPartite() => partitaApiProvider.tutte();
  Future<PartitaModel> creaPartita(String nomeSquadra1, String nomeSquadra2) =>
      partitaApiProvider.crea(nomeSquadra1, nomeSquadra2);
  Future<PartitaModel> singolaPartita(int id) => partitaApiProvider.singola(id);
  Future<bool> aggiornaPartita(PartitaModel partitaDaAggiornare) =>
      partitaApiProvider.aggiorna(partitaDaAggiornare);
  Future<bool> eliminaPartita(int id) => partitaApiProvider.elimina(id);

  Future<List<GruppoModel>> fetchAllGruppi() => gruppoApiProvider.getGruppi();
}
