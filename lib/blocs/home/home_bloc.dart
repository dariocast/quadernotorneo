import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/repositories/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = Repository();

  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoaded) {
      yield HomeLoading();
      try {
        final partite = await _repository.listaPartite();
        final gruppi = await _repository.gruppi();
        yield HomeSuccess(partite: partite, infoGruppi: gruppi);
      } catch (e) {
        debugPrint(e.toString());
        yield HomeFailure();
      }
    }
  }
}
