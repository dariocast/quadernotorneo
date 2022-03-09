import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'gruppi_event.dart';
part 'gruppi_state.dart';

class GruppiBloc extends Bloc<GruppiEvent, GruppiState> {
  final _repository = Repository();

  GruppiBloc() : super(GruppiInitial()) {
    on<GruppiLoaded>((event, emit) => _handleGruppiLoaded(event, emit));
    on<GruppiCrea>((event, emit) => _handleGruppiCrea(event, emit));
    on<GruppiAggiorna>((event, emit) => _handleGruppiAggiorna(event, emit));
    on<GruppiElimina>((event, emit) => _handleGruppiElimina(event, emit));
  }

  _handleGruppiLoaded(GruppiLoaded event, Emitter<GruppiState> emit) async {
    emit(GruppiLoading());
    try {
      final gruppi = await _repository.gruppi();
      emit(GruppiLoadSuccess(gruppi));
    } catch (e) {
      developer.log(e.toString(), name: 'blocs.GruppiBloc');
      emit(GruppiLoadFailure('Impossibile caricare i gruppi al momento'));
    }
  }

  _handleGruppiCrea(GruppiCrea event, Emitter<GruppiState> emit) async {
    emit(GruppiLoading());
    try {
      final gruppoCreato =
          await _repository.creaGruppo(event.nome, event.girone, event.logo);
      final gruppi = await _repository.gruppi();
      emit(GruppiLoadSuccess(gruppi));
    } catch (e) {
      developer.log(e.toString(), name: 'blocs.GruppiBloc');
      emit(GruppiLoadFailure('Impossibile creare gruppi al momento'));
    }
  }

  _handleGruppiAggiorna(GruppiAggiorna event, Emitter<GruppiState> emit) async {
    emit(GruppiLoading());
    try {
      final gruppoAggiornato =
          await _repository.aggiornaGruppo(event.aggiornato);
      final gruppi = await _repository.gruppi();
      emit(GruppiLoadSuccess(gruppi));
    } catch (e) {
      developer.log(e.toString(), name: 'blocs.GruppiBloc');
      emit(GruppiLoadFailure('Impossibile aggiornare gruppi al momento'));
    }
  }

  _handleGruppiElimina(GruppiElimina event, Emitter<GruppiState> emit) async {
    emit(GruppiLoading());
    try {
      final gruppoEliminato = await _repository.eliminaGruppo(event.id);
      final gruppi = await _repository.gruppi();
      emit(GruppiLoadSuccess(gruppi));
    } catch (e) {
      developer.log(e.toString(), name: 'blocs.GruppiBloc');
      emit(GruppiLoadFailure('Impossibile caricare i gruppi al momento'));
    }
  }

  @override
  void onTransition(Transition<GruppiEvent, GruppiState> transition) {
    super.onTransition(transition);
    developer.log('$transition', name: 'blocs.GruppiBloc');
  }
}
