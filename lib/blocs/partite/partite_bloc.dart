import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/extensions/order_by_comparator.dart';
import '../../models/models.dart';
import '../../repositories/repository.dart';
import '../../utils/log_helper.dart';

part 'partite_event.dart';
part 'partite_state.dart';

class PartiteBloc extends Bloc<PartiteEvent, PartiteState> {
  final _repository = Repository();

  PartiteBloc() : super(PartiteInitial()) {
    on<PartiteLoaded>((event, emit) async {
      emit(PartiteLoading());
      try {
        final partite = await _repository.listaPartite(torneo: event.torneo);
        final gruppi = await _repository.gruppi();
        emit(PartiteSuccess(
            torneo: event.torneo,
            partite: partite,
            infoGruppi: gruppi,
            orderBy: OrderBy.DATA_DESC));
      } catch (e) {
        QTLog.log(e.toString(), name: 'blocs.partite');
        emit(PartiteFailure());
      }
    });

    on<PartiteOrderBy>((event, emit) {
      PartiteSuccess stateSuccess = state as PartiteSuccess;
      emit(PartiteLoading());
      stateSuccess.partite.sort(event.orderBy.comparator);
      emit(
        stateSuccess.copyWith(
            partite: stateSuccess.partite, orderBy: event.orderBy),
      );
    });
  }
}
