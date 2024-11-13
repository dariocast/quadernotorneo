import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'marcatori_event.dart';
part 'marcatori_state.dart';

class MarcatoriBloc extends Bloc<MarcatoriEvent, MarcatoriState> {
  final Repository _repo = Repository();
  MarcatoriBloc() : super(MarcatoriInitial()) {
    on<MarcatoriLoaded>((event, emit) async {
      emit(MarcatoriLoading());
      try {
        final List<Giocatore> marcatori = List.empty(growable: true);
        final gruppi = await _repo.gruppi(event.torneo);
        for (var gruppo in gruppi) {
          marcatori.addAll(await _repo.marcatori(gruppo.nome));
        }
        Map<String, String> loghi = {};
        for (var gruppo in gruppi) {
          loghi.putIfAbsent(gruppo.nome, () => gruppo.logo);
        }
        // order marcatori by gol
        marcatori.sort((a, b) => b.gol.compareTo(a.gol));
        emit(MarcatoriLoadSuccess(marcatori.cast<Giocatore>(), loghi));
      } catch (e) {
        emit(MarcatoriLoadFailure());
      }
    });
  }
}
