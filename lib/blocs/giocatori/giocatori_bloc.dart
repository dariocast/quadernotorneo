import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'giocatori_event.dart';
part 'giocatori_state.dart';

class GiocatoriBloc extends Bloc<GiocatoriEvent, GiocatoriState> {
  final _repository = Repository();

  GiocatoriBloc() : super(GiocatoriInitial()) {
    on<GiocatoriLoaded>((event, emit) => _handleGiocatoriLoaded(event, emit));
    on<GiocatoriCrea>((event, emit) => _handleGiocatoriCrea(event, emit));
    on<GiocatoriAggiorna>(
        (event, emit) => _handleGiocatoriAggiorna(event, emit));
    on<GiocatoriElimina>((event, emit) => _handleGiocatoriElimina(event, emit));
  }

  _handleGiocatoriLoaded(
      GiocatoriLoaded event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    if (event is GiocatoriLoaded) {
      try {
        final giocatori = await _repository.giocatori();
        giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
        emit(GiocatoriLoadSuccess(giocatori));
      } catch (e) {
        debugPrint(e.toString());
        emit(GiocatoriLoadFailure(
            'Impossibile caricare i giocatori al momento'));
      }
    }
  }

  _handleGiocatoriCrea(
      GiocatoriCrea event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    try {
      final created = await _repository.creaGiocatore(
          event.nome, event.gruppo, event.immagine, event.photo);
      final giocatori = await _repository.giocatori();
      emit(GiocatoriLoadSuccess(giocatori));
    } catch (e) {
      debugPrint(e.toString());
      emit(GiocatoriLoadFailure('Impossibile creare i giocatori al momento'));
    }
  }

  _handleGiocatoriAggiorna(
      GiocatoriAggiorna event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    try {
      final updated = await _repository.aggiornaGiocatore(
          event.aggiornato, event.nuovaPhoto);
      final giocatori = await _repository.giocatori();
      giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
      updated
          ? emit(GiocatoriLoadSuccess(giocatori))
          : emit(GiocatoriLoadFailure('Il giocatore non è stato aggiornato'));
    } catch (e) {
      debugPrint(e.toString());
      emit(GiocatoriLoadFailure(
          'Impossibile aggiornare i giocatori al momento'));
    }
  }

  _handleGiocatoriElimina(
      GiocatoriElimina event, Emitter<GiocatoriState> emit) async {
    emit(GiocatoriLoading());
    try {
      final deleted = await _repository.eliminaGiocatore(event.id);
      final giocatori = await _repository.giocatori();
      giocatori.sort((a, b) => a.gruppo.compareTo(b.gruppo));
      deleted
          ? emit(GiocatoriLoadSuccess(giocatori))
          : emit(GiocatoriLoadFailure('Il giocatore non è stato eliminato'));
    } catch (e) {
      debugPrint(e.toString());
      emit(
          GiocatoriLoadFailure('Impossibile eliminare i giocatori al momento'));
    }
  }
}