part of 'partite_bloc.dart';

abstract class PartiteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PartiteLoaded extends PartiteEvent {
  final String? torneo;

  PartiteLoaded(this.torneo);
}

class PartiteCreaPartita extends PartiteEvent {
  final DateTime data;
  final TimeOfDay orario;
  final String gruppoUno;
  final String gruppoDue;

  PartiteCreaPartita(this.data, this.orario, this.gruppoUno, this.gruppoDue);

  @override
  List<Object> get props => [data, orario, gruppoUno, gruppoDue];
}

class PartiteOrderBy extends PartiteEvent {
  final OrderBy orderBy;

  PartiteOrderBy(this.orderBy);
  @override
  List<Object> get props => [orderBy];
}
