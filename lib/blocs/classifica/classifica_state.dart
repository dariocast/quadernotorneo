part of 'classifica_bloc.dart';

abstract class ClassificaState extends Equatable {
  const ClassificaState();

  @override
  List<Object> get props => [];
}

class ClassificaInitial extends ClassificaState {}

class ClassificaLoading extends ClassificaState {}

class ClassificaLoadFailure extends ClassificaState {}

class ClassificaLoadSuccess extends ClassificaState {
  final List<Gruppo> gruppi;

  const ClassificaLoadSuccess(this.gruppi);
}
