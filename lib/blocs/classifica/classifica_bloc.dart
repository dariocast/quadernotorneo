import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';
import '../../utils/log_helper.dart';

part 'classifica_event.dart';
part 'classifica_state.dart';

class ClassificaBloc extends Bloc<ClassificaEvent, ClassificaState> {
  final String? torneo;
  final Repository _repo = Repository();

  ClassificaBloc(this.torneo) : super(ClassificaInitial()) {
    on<ClassificaLoaded>((event, emit) async {
      print("ClassificaLoaded event triggered");
      emit(ClassificaLoading());
      try {
        final gruppi = await _repo.gruppi(torneo);
        print("Data loaded successfully: $gruppi");
        emit(ClassificaLoadSuccess(gruppi));
      } catch (e) {
        QTLog.log(e.toString(), name: 'blocs.classifica');
        print("Error loading data: $e");
        emit(ClassificaLoadFailure());
      }
    });
  }
}
