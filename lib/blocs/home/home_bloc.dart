import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = Repository();

  HomeBloc() : super(HomeInitial()) {
    on<HomeStarted>((event, emit) async {
      emit(HomeLoadInProgress());
      final partite = await _repository.listaPartite();
      final tornei = partite.map((e) => e.torneo).toSet().toList();
      final gruppi = await _repository.gruppi();

      emit(HomeLoadSuccess(
        tornei: tornei,
        partite: partite,
        gruppi: gruppi,
      ));
    });
  }
}
