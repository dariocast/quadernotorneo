import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../repositories/repository.dart';

part 'crea_event.dart';
part 'crea_state.dart';

class CreaBloc extends Bloc<CreaEvent, CreaState> {
  final Repository _repository = Repository();
  CreaBloc() : super(CreaState());

  @override
  Stream<CreaState> mapEventToState(
    CreaEvent event,
  ) async* {
    yield state.copyWith(isLoading: true);
    if (event is CreaLoaded) {
      final gruppi = await _repository.gruppi();
      final nomiGruppi = gruppi.map((e) => e.nome).toList();
      final isValid = state.gruppoUno != null &&
          state.gruppoDue != null &&
          state.data != null &&
          state.orario != null;
      yield state.copyWith(
        gruppi: nomiGruppi,
        isLoading: false,
        isValid: isValid,
      );
    } else if (event is CreaGruppoUnoChanged) {
      final isValid =
          state.gruppoDue != null && state.data != null && state.orario != null;
      yield state.copyWith(
        gruppoUno: event.gruppo,
        isLoading: false,
        isValid: isValid,
      );
    } else if (event is CreaGruppoDueChanged) {
      final isValid =
          state.gruppoUno != null && state.data != null && state.orario != null;
      yield state.copyWith(
        gruppoDue: event.gruppo,
        isLoading: false,
        isValid: isValid,
      );
    } else if (event is CreaDataChanged) {
      final isValid = state.gruppoUno != null &&
          state.gruppoDue != null &&
          state.orario != null;
      yield state.copyWith(
        data: event.data,
        isLoading: false,
        isValid: isValid,
      );
    } else if (event is CreaOrarioChanged) {
      final isValid = state.gruppoUno != null &&
          state.gruppoDue != null &&
          state.data != null;
      yield state.copyWith(
        orario: event.orario,
        isLoading: false,
        isValid: isValid,
      );
    } else if (event is CreaSubmit) {
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
        yield state.copyWith(isLoading: false, creationSuccess: true);
      }
    }
  }
}
