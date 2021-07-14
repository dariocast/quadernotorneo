import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'marcatori_event.dart';
part 'marcatori_state.dart';

class MarcatoriBloc extends Bloc<MarcatoriEvent, MarcatoriState> {
  final Repository _repo = Repository();
  MarcatoriBloc() : super(MarcatoriInitial());

  @override
  Stream<MarcatoriState> mapEventToState(
    MarcatoriEvent event,
  ) async* {
    if (event is MarcatoriLoaded) {
      yield MarcatoriLoading();
      try {
        final marcatori = await _repo.marcatori();
        final gruppi = await _repo.gruppi();
        Map<String, String> loghi = Map();
        gruppi.forEach((gruppo) {
          loghi.putIfAbsent(gruppo.nome, () => gruppo.logo);
        });
        yield MarcatoriLoadSuccess(marcatori, loghi);
      } catch (e) {
        yield MarcatoriLoadFailure();
      }
    }
  }
}
