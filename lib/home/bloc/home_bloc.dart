import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/home/models/models.dart';
import 'package:quaderno_flutter/home/repositories/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class PartitaBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = Repository();

  PartitaBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    final currentState = state;
    if (event is HomeLoaded) {
      try {
        if (!(currentState is HomeFailure)) {
          final partite = await _repository.listaPartite();
          yield HomeSuccess(partite: partite);
          return;
        }
      } catch (_) {
        yield HomeFailure();
      }
    }
  }
}
