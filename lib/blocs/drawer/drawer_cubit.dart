import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/database.dart';
import '../../repositories/repository.dart';
import '../../utils/log_helper.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final Repository _repository = Repository();
  final String? torneo;

  DrawerCubit(this.torneo) : super(DrawerState()) {
    QTLog.log("DrawerCubit initialized with torneo: $torneo",
        name: 'cubit.drawer');
  }

  Future<void> aggiornaClassifica() async {
    QTLog.log("Updating classifica for torneo: $torneo", name: 'cubit.drawer');
    emit(state.copyWith(loading: true));

    try {
      final updated = await _repository.aggiornaStatistiche(torneo);
      emit(state.copyWith(
          updateClassificaSuccess: updated.isNotEmpty, loading: false));
      QTLog.log("Classifica updated successfully: ${updated.isNotEmpty}",
          name: 'cubit.drawer');
    } catch (e) {
      QTLog.log("Error updating classifica: $e", name: 'cubit.drawer');
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> resetClassifica() async {
    QTLog.log("Resetting classifica for torneo: $torneo", name: 'cubit.drawer');
    emit(state.copyWith(loading: true));

    try {
      final updated =
          await _repository.aggiornaStatistiche(torneo, reset: true);
      emit(state.copyWith(
          updateClassificaSuccess: updated.isNotEmpty, loading: false));
      QTLog.log("Classifica reset successfully: ${updated.isNotEmpty}",
          name: 'cubit.drawer');
    } catch (e) {
      QTLog.log("Error resetting classifica: $e", name: 'cubit.drawer');
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> aggiornaMarcatori() async {
    QTLog.log("Updating marcatori for torneo: $torneo", name: 'cubit.drawer');
    emit(state.copyWith(loading: true));

    try {
      final updated = await _repository.aggiornaMarcatori(torneo);
      emit(state.copyWith(
          updateMarcatoriSuccess: updated.isNotEmpty, loading: false));
      QTLog.log("Marcatori updated successfully: ${updated.isNotEmpty}",
          name: 'cubit.drawer');
    } catch (e) {
      QTLog.log("Error updating marcatori: $e", name: 'cubit.drawer');
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> resetTorneo() async {
    QTLog.log("Resetting torneo: $torneo", name: 'cubit.drawer');
    emit(state.copyWith(loading: true));

    try {
      await Database.delete('torneo');
      emit(state.copyWith(loading: false));
      QTLog.log("Torneo reset successfully", name: 'cubit.drawer');
    } catch (e) {
      QTLog.log("Error resetting torneo: $e", name: 'cubit.drawer');
      emit(state.copyWith(loading: false));
    }
  }
}
