import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../repositories/repository.dart';

part 'crea_event.dart';
part 'crea_state.dart';

class CreaBloc extends Bloc<CreaEvent, CreaState> {
  final Repository _repository = Repository();
  CreaBloc() : super(CreaState()) {
    // This section set the handlers for each kind of event
    on<CreaLoaded>((event, emit) => _handleCreaLoadedEvent(event, emit));
    on<CreaGruppoUnoChanged>(
        (event, emit) => _handleCreaGruppoUnoChangedEvent(event, emit));
    on<CreaGruppoDueChanged>(
        (event, emit) => _handleCreaGruppoDueChangedEvent(event, emit));
    on<CreaDataChanged>(
        (event, emit) => _handleCreaDataChangedEvent(event, emit));
    on<CreaOrarioChanged>(
        (event, emit) => _handleCreaOrarioChangedEvent(event, emit));
    on<CreaSubmit>((event, emit) => _handleCreaSubmitEvent(event, emit));
  }

  _handleCreaLoadedEvent(event, emit) async {
    final gruppi = await _repository.gruppi();
    final nomiGruppi = gruppi.map((e) => e.nome).toList();
    final isValid = state.gruppoUno != null &&
        state.gruppoDue != null &&
        state.data != null &&
        state.orario != null;
    emit(state.copyWith(
      gruppi: nomiGruppi,
      hasGruppi: nomiGruppi.isNotEmpty,
      isLoading: false,
      isValid: isValid,
    ));
  }

  _handleCreaSubmitEvent(CreaSubmit event, Emitter<CreaState> emit) async {
    if (state.isValid) {
      await _repository.creaPartita(
        state.gruppoUno!,
        state.gruppoDue!,
        DateTime(
          state.data!.year,
          state.data!.month,
          state.data!.day,
          state.orario!.hour,
          state.orario!.minute,
        ),
      );
      emit(state.copyWith(isLoading: false, creationSuccess: true));
    }
  }

  _handleCreaOrarioChangedEvent(
      CreaOrarioChanged event, Emitter<CreaState> emit) {
    final isValid = state.gruppoUno != null &&
        state.gruppoDue != null &&
        state.data != null;
    emit(state.copyWith(
      orario: event.orario,
      isLoading: false,
      isValid: isValid,
    ));
  }

  _handleCreaDataChangedEvent(CreaDataChanged event, Emitter<CreaState> emit) {
    final isValid = state.gruppoUno != null &&
        state.gruppoDue != null &&
        state.orario != null;
    emit(state.copyWith(
      data: event.data,
      isLoading: false,
      isValid: isValid,
    ));
  }

  _handleCreaGruppoDueChangedEvent(
      CreaGruppoDueChanged event, Emitter<CreaState> emit) {
    final isValid =
        state.gruppoUno != null && state.data != null && state.orario != null;
    emit(state.copyWith(
      gruppoDue: event.gruppo,
      isLoading: false,
      isValid: isValid,
    ));
  }

  _handleCreaGruppoUnoChangedEvent(
      CreaGruppoUnoChanged event, Emitter<CreaState> emit) {
    final isValid =
        state.gruppoDue != null && state.data != null && state.orario != null;
    emit(state.copyWith(
      gruppoUno: event.gruppo,
      isLoading: false,
      isValid: isValid,
    ));
  }
}
