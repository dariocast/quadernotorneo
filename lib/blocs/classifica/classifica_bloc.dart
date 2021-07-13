import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/repositories/repository.dart';

part 'classifica_event.dart';
part 'classifica_state.dart';

class ClassificaBloc extends Bloc<ClassificaEvent, ClassificaState> {
  final Repository _repo = Repository();

  ClassificaBloc() : super(ClassificaInitial());

  @override
  Stream<ClassificaState> mapEventToState(
    ClassificaEvent event,
  ) async* {
    if (event is ClassificaLoaded) {
      yield ClassificaLoading();
      try {
        final gruppi = await _repo.gruppi();
        yield ClassificaLoadSuccess(gruppi);
      } catch (e) {
        yield ClassificaLoadFailure();
      }
    }
  }
}
