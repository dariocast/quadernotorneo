import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'classifica_event.dart';
part 'classifica_state.dart';

class ClassificaBloc extends Bloc<ClassificaEvent, ClassificaState> {
  final Repository _repo = Repository();

  ClassificaBloc() : super(ClassificaInitial()) {
    on<ClassificaLoaded>((event, emit) async {
      emit(ClassificaLoading());
      try {
        final gruppi = await _repo.gruppi();
        emit(ClassificaLoadSuccess(gruppi));
      } catch (e) {
        debugPrint(e.toString());
        emit(ClassificaLoadFailure());
      }
    });
  }
}