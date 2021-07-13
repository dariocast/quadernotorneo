part of 'marcatori_bloc.dart';

abstract class MarcatoriEvent extends Equatable {
  const MarcatoriEvent();

  @override
  List<Object> get props => [];
}

class MarcatoriLoaded extends MarcatoriEvent {}
