part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeEvent {}

class HomeCreaPartita extends HomeEvent {
  final DateTime data;
  final TimeOfDay orario;
  final String gruppoUno;
  final String gruppoDue;

  HomeCreaPartita(this.data, this.orario, this.gruppoUno, this.gruppoDue);

  List<Object> get props => [data, orario, gruppoUno, gruppoDue];
}
