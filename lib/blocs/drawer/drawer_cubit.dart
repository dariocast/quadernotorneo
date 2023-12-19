import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repository.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final Repository _repository = Repository();
  final String? torneo;
  DrawerCubit(this.torneo) : super(DrawerState());

  aggiornaClassifica() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaStatistiche(torneo);
    emit(state.copyWith(
        updateClassificaSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }

  resetClassifica() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaStatistiche(torneo, reset: true);
    emit(state.copyWith(
        updateClassificaSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }

  aggiornaMarcatori() async {
    emit(state.copyWith(loading: true));
    final updated = await _repository.aggiornaMarcatori(torneo);
    emit(state.copyWith(
        updateMarcatoriSuccess: updated.isNotEmpty ? true : false,
        loading: false));
  }
}
