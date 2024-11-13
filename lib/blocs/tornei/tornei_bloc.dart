import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/database.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';
import '../../utils/log_helper.dart';

part 'tornei_event.dart';
part 'tornei_state.dart';

class TorneiBloc extends Bloc<TorneiEvent, TorneiState> {
  final _repository = Repository();

  TorneiBloc() : super(TorneiInitial()) {
    on<TorneiLoaded>((event, emit) async {
      QTLog.log("TorneiLoaded event triggered", name: 'blocs.tornei');
      emit(TorneiLoading());
      try {
        QTLog.log("Fetching selected torneo from database",
            name: 'blocs.tornei');
        final String? torneoSelezionato = await Database.get('torneo');
        QTLog.log("Selected torneo: $torneoSelezionato", name: 'blocs.tornei');

        QTLog.log("Fetching list of tornei from repository",
            name: 'blocs.tornei');
        final tornei = await _repository.tornei();
        QTLog.log("Tornei fetched successfully: ${tornei.length} items",
            name: 'blocs.tornei');

        emit(TorneiLoadSuccess(tornei, torneoSelezionato));
      } catch (e) {
        QTLog.log("Error in TorneiLoaded: $e", name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });

    on<TorneiCrea>((event, emit) async {
      QTLog.log("TorneiCrea event triggered with name: ${event.nome}",
          name: 'blocs.tornei');
      emit(TorneiLoading());
      try {
        QTLog.log("Creating torneo with name: ${event.nome}",
            name: 'blocs.tornei');
        await _repository.creaTorneo(event.nome);
        QTLog.log("Torneo created successfully, reloading list",
            name: 'blocs.tornei');
        add(TorneiLoaded());
      } catch (e) {
        QTLog.log("Error in TorneiCrea: $e", name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });

    on<TorneoSelezionato>((event, emit) async {
      QTLog.log(
          "TorneoSelezionato event triggered for torneo: ${event.torneo.name}",
          name: 'blocs.tornei');
      try {
        QTLog.log("Saving selected torneo to database: ${event.torneo.name}",
            name: 'blocs.tornei');
        await Database.put('torneo', event.torneo.name);
        QTLog.log("Torneo selection saved successfully", name: 'blocs.tornei');
      } catch (e) {
        QTLog.log("Error in TorneoSelezionato: $e", name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });

    on<TorneiElimina>((event, emit) async {
      QTLog.log(
          "TorneiElimina event triggered for torneo: ${event.torneo.name}",
          name: 'blocs.tornei');
      emit(TorneiLoading());
      try {
        QTLog.log("Deleting torneo: ${event.torneo.name}",
            name: 'blocs.tornei');
        await _repository.eliminaTorneo(event.torneo.id);
        QTLog.log("Torneo deleted successfully, reloading list",
            name: 'blocs.tornei');
        add(TorneiLoaded());
      } catch (e) {
        QTLog.log("Error in TorneiElimina: $e", name: 'blocs.tornei');
        emit(TorneiLoadFailure());
      }
    });
  }
}
