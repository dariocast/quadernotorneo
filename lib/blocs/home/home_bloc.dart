import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/helpers/extensions/order_by_comparator.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = Repository();

  HomeBloc() : super(HomeInitial()) {
    on<HomeLoaded>((event, emit) async {
      emit(HomeLoading());
      try {
        final partite = await _repository.listaPartite();
        final gruppi = await _repository.gruppi();
        emit(HomeSuccess(
            partite: partite, infoGruppi: gruppi, orderBy: OrderBy.DATA_DESC));
      } catch (e) {
        debugPrint(e.toString());
        emit(HomeFailure());
      }
    });

    on<HomeOrderBy>((event, emit) {
      HomeSuccess stateSuccess = state as HomeSuccess;
      emit(HomeLoading());
      stateSuccess.partite.sort(event.orderBy.comparator);
      emit(
        stateSuccess.copyWith(
            partite: stateSuccess.partite, orderBy: event.orderBy),
      );
    });
  }
}
