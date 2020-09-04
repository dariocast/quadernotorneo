import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/home/models/models.dart';
import 'package:quaderno_flutter/home/repositories/repository.dart';

part 'partita_event.dart';
part 'partita_state.dart';

class PartitaBloc extends Bloc<PartitaEvent, PartitaState> {
  final _repository = Repository();

  PartitaBloc() : super(PartitaInitial());

  @override
  Stream<PartitaState> mapEventToState(PartitaEvent event) async* {
    final currentState = state;
    if (event is PartitaLoaded) {
      try {
        if (!(currentState is PartitaFailure)) {
          final partite = await _repository.listaPartite();
          yield PartitaSuccess(partite: partite);
          return;
        }
      } catch (_) {
        yield PartitaFailure();
      }
    }
  }
}
