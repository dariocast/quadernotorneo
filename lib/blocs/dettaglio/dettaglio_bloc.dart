import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/models/models.dart';

part 'dettaglio_event.dart';
part 'dettaglio_state.dart';

class DettaglioBloc extends Bloc<DettaglioEvent, DettaglioState> {
  DettaglioBloc() : super(DettaglioState());

  @override
  Stream<DettaglioState> mapEventToState(
    DettaglioEvent event,
  ) async* {
    yield state.copyWith(loading: true);
    if (event is DettaglioLoaded) {
      yield state.copyWith(
        partita: event.partita,
        loading: false,
      );
    }
  }
}
