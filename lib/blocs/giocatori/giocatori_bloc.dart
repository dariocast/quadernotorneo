import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/repositories/repository.dart';

part 'giocatori_event.dart';
part 'giocatori_state.dart';

class GiocatoriBloc extends Bloc<GiocatoriEvent, GiocatoriState> {
  final _repository = Repository();

  GiocatoriBloc() : super(GiocatoriInitial());

  @override
  Stream<GiocatoriState> mapEventToState(
    GiocatoriEvent event,
  ) async* {
    yield GiocatoriLoading();

    if (event is GiocatoriLoaded) {
      try {
        final giocatori = await _repository.giocatori();
        giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
        yield GiocatoriLoadSuccess(giocatori);
      } catch (_) {
        yield GiocatoriLoadFailure(
            'Impossibile caricare i giocatori al momento');
      }
    } else if (event is GiocatoriCrea) {
      try {
        final giocatore =
            await _repository.creaGiocatore(event.nome, event.gruppo);
        final giocatori = await _repository.giocatori();
        giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
        yield GiocatoriLoadSuccess(giocatori);
      } catch (_) {
        yield GiocatoriLoadFailure('Impossibile creare i giocatori al momento');
      }
    } else if (event is GiocatoriAggiorna) {
      try {
        final updated = await _repository.aggiornaGiocatore(event.aggiornato);
        final giocatori = await _repository.giocatori();
        giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
        yield updated
            ? GiocatoriLoadSuccess(giocatori)
            : GiocatoriLoadFailure('Il giocatore non è stato aggiornato');
      } catch (_) {
        yield GiocatoriLoadFailure(
            'Impossibile aggiornare i giocatori al momento');
      }
    } else if (event is GiocatoriElimina) {
      try {
        final deleted = await _repository.eliminaGiocatore(event.id);
        final giocatori = await _repository.giocatori();
        giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
        yield deleted
            ? GiocatoriLoadSuccess(giocatori)
            : GiocatoriLoadFailure('Il giocatore non è stato eliminato');
      } catch (_) {
        yield GiocatoriLoadFailure(
            'Impossibile eliminare i giocatori al momento');
      }
    }
  }
}
