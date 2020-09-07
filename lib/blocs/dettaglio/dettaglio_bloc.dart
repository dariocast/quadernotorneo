import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dettaglio_event.dart';
part 'dettaglio_state.dart';

class DettaglioBloc extends Bloc<DettaglioEvent, DettaglioState> {
  DettaglioBloc() : super(DettaglioInitial());

  @override
  Stream<DettaglioState> mapEventToState(
    DettaglioEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
