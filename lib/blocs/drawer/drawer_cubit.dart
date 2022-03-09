import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repository.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final Repository _repository = Repository();
  DrawerCubit() : super(DrawerState());

  aggiornaClassifica() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaStatistiche();
    emit(state.copyWith(
        updateClassificaSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }

  resetClassifica() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaStatistiche(reset: true);
    emit(state.copyWith(
        updateClassificaSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }

  aggiornaMarcatori() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaMarcatori();
    emit(state.copyWith(
        updateMarcatoriSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }
}
