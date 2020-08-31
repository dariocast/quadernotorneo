import 'dart:async';
import 'package:quaderno_flutter/src/models/partita_model.dart';

import 'gruppo_api_provider.dart';
import 'partita_api_provider.dart';
import '../models/gruppo_model.dart';

class Repository {
  final gruppoApiProvider = GruppoApiProvider();
  final partitaApiProvider = PartitaApiProvider();

  Future<List<PartitaModel>> fetchAllPartite() =>
      partitaApiProvider.getPartite();
  Future<List<GruppoModel>> fetchAllGruppi() => gruppoApiProvider.getGruppi();
}
