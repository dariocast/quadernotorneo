import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';
import '../../utils/log_helper.dart';

part 'tornei_event.dart';
part 'tornei_state.dart';

class TorneiBloc extends Bloc<TorneiEvent, TorneiState> {
  final _repository = Repository();

  TorneiBloc() : super(TorneiInitial()) {
    on<TorneiLoaded>((event, emit) async {
      emit(TorneiLoading());
      try {
        final tornei = await _repository.tornei();
        emit(TorneiLoadSuccess(tornei));
      } catch (e) {
        QTLog.log(e.toString(), name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });
    on<TorneiCrea>((event, emit) {
      emit(TorneiLoading());
      try {
        _repository.creaTorneo(event.nome);
        add(TorneiLoaded());
      } catch (e) {
        QTLog.log(e.toString(), name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });
  }
}
