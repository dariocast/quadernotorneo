part of 'classifica_bloc.dart';

abstract class ClassificaEvent extends Equatable {
  const ClassificaEvent();

  @override
  List<Object> get props => [];
}

class ClassificaLoaded extends ClassificaEvent {}
