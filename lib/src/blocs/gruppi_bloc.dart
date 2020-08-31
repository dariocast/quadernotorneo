import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/gruppo_model.dart';

class GruppiBloc {
  final _repository = Repository();
  final _gruppiFetcher = PublishSubject<List<GruppoModel>>();

  Observable<List<GruppoModel>> get gruppi => _gruppiFetcher.stream;

  fetchAllGruppi() async {
    List<GruppoModel> gruppiModel = await _repository.fetchAllGruppi();
    _gruppiFetcher.sink.add(gruppiModel);
  }

  dispose() {
    _gruppiFetcher.close();
  }
}

final bloc = GruppiBloc();
