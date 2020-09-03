import 'dart:async';

import '../repositories/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/models.dart';

class PartiteBloc {
  final _repository = Repository();
  final _partiteFetcher = PublishSubject<List<PartitaModel>>();

  Observable<List<PartitaModel>> get partite => _partiteFetcher.stream;

  fetchAllPartite() async {
    List<PartitaModel> listPartiteModel = await _repository.listaPartite();
    _partiteFetcher.sink.add(listPartiteModel);
  }

  dispose() {
    _partiteFetcher.close();
  }
}

final bloc = PartiteBloc();
