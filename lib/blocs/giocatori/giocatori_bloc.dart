import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'giocatori_event.dart';
part 'giocatori_state.dart';

class GiocatoriBloc extends Bloc<GiocatoriEvent, GiocatoriState> {
  final _repository = Repository();

  GiocatoriBloc() : super(GiocatoriInitial()) {
    on<GiocatoriLoaded>((event, emit) => _handleGiocatoriLoaded(event, emit));
    on<GiocatoriCrea>((event, emit) => _handleGioctoriCrea(event, emit));
    on<GiocatoriAggiorna>(
        (event, emit) => _handleGioctoriAggiorna(event, emit));
    on<GiocatoriElimina>((event, emit) => _handleGioctoriElimina(event, emit));
  }

  _handleGiocatoriLoaded(
      GiocatoriLoaded event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    if (event is GiocatoriLoaded) {
      try {
        final giocatori = await _repository.giocatori();
        giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
        emit(GiocatoriLoadSuccess(giocatori));
      } catch (_) {
        emit(GiocatoriLoadFailure(
            'Impossibile caricare i giocatori al momento'));
      }
    }
  }

  _handleGioctoriCrea(GiocatoriCrea event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    try {
      final giocatore = await _repository.creaGiocatore(
          event.nome, event.gruppo, event.immagine);
      final giocatori = await _repository.giocatori();
      giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
      emit(GiocatoriLoadSuccess(giocatori));
    } catch (_) {
      emit(GiocatoriLoadFailure('Impossibile creare i giocatori al momento'));
    }
  }

  _handleGioctoriAggiorna(
      GiocatoriAggiorna event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    try {
      final updated = await _repository.aggiornaGiocatore(event.aggiornato);
      final giocatori = await _repository.giocatori();
      giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
      updated
          ? emit(GiocatoriLoadSuccess(giocatori))
          : emit(GiocatoriLoadFailure('Il giocatore non è stato aggiornato'));
    } catch (_) {
      emit(GiocatoriLoadFailure(
          'Impossibile aggiornare i giocatori al momento'));
    }
  }

  _handleGioctoriElimina(
      GiocatoriElimina event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    try {
      final deleted = await _repository.eliminaGiocatore(event.id);
      final giocatori = await _repository.giocatori();
      giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
      deleted
          ? GiocatoriLoadSuccess(giocatori)
          : GiocatoriLoadFailure('Il giocatore non è stato eliminato');
    } catch (_) {
      emit(
          GiocatoriLoadFailure('Impossibile eliminare i giocatori al momento'));
    }
  }
}
