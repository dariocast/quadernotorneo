import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/partita_model.dart';

class GruppiBloc {
  final _repository = Repository();
  final _partiteFetcher = PublishSubject<List<PartitaModel>>();

  Observable<List<PartitaModel>> get partite => _partiteFetcher.stream;

  fetchAllPartite() async {
    List<PartitaModel> listPartiteModel = await _repository.fetchAllPartite();
    _partiteFetcher.sink.add(listPartiteModel);
  }

  dispose() {
    _partiteFetcher.close();
  }
}

final bloc = GruppiBloc();
