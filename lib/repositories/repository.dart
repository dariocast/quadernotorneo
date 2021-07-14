import 'dart:async';
import '../models/models.dart';
import 'admin_api_provider.dart';
import 'partita_api_provider.dart';

class Repository {
  final partitaApiProvider = PartitaApiProvider();
  final adminApiProvider = AdminApiProvider();

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
  Future<bool> aggiornaClassifica() => adminApiProvider.aggiornaClassifica();
  Future<List<Marcatore>> aggiornaMarcatori() =>
      adminApiProvider.aggiornaMarcatori();
  Future<List<Marcatore>> marcatori() => partitaApiProvider.marcatori();
}
