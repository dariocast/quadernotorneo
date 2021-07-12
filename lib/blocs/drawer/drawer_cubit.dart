import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/repositories/repository.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final Repository _repository = Repository();
  DrawerCubit() : super(DrawerState());

  aggiornaClassifica() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaClassifica();
    emit(state.copyWith(updateClassificaSuccess: updated, loading: false));
  }

  aggiornaMarcatori() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaMarcatori();
    emit(state.copyWith(
        updateMarcatoriSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }
}
