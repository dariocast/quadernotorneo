part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeFailure extends HomeState {}

class HomeSuccess extends HomeState {
  final List<PartitaModel> partite;

  const HomeSuccess({this.partite});

  HomeSuccess copyWith({
    List<PartitaModel> partite,
    bool hasReachedMax,
  }) {
    return HomeSuccess(partite: partite ?? this.partite);
  }

  @override
  List<Object> get props => [partite];

  @override
  String toString() => 'HomeSuccess { partite: ${partite.length}}';
}
