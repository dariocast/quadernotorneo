part of 'tornei_bloc.dart';

abstract class TorneiState extends Equatable {
  const TorneiState();

  @override
  List<Object> get props => [];
}

class TorneiInitial extends TorneiState {}

class TorneiLoading extends TorneiState {}

class TorneiLoadFailure extends TorneiState {}

class TorneiLoadSuccess extends TorneiState {
  final List<String> tornei;

  TorneiLoadSuccess(this.tornei);
}
