part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadInProgress extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final List<String> tornei;
  final List<Partita> partite;
  final List<Gruppo> gruppi;

  HomeLoadSuccess(
      {required this.tornei, required this.partite, required this.gruppi});
}

class HomeLoadFailure extends HomeState {}
