part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeFailure extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<PartitaModel> partite;

  const HomeSuccess({required this.partite});

  @override
  List<Object> get props => [partite];

  @override
  String toString() => 'HomeSuccess { partite: ${partite.length}}';
}
