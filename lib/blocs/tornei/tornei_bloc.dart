import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
        List<String> torneiDuplicati = [];
        final partite = await _repository.listaPartite();
        for (var partita in partite) {
          torneiDuplicati.add(partita.torneo);
        }
        final tornei = torneiDuplicati.toSet().toList();
        emit(TorneiLoadSuccess(tornei));
      } catch (e) {
        QTLog.log(e.toString(), name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });
    on<TorneiCrea>((event, emit) {
      // TODO: implement event handler
    });
  }
}
