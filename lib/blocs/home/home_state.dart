part of 'home_bloc.dart';

enum OrderBy { DATA_DESC, DATA_ASC, ID_DESC, ID_ASC }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeFailure extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Partita> partite;
  final List<Gruppo> infoGruppi;
  final OrderBy orderBy;

  const HomeSuccess(
      {required this.partite, required this.infoGruppi, required this.orderBy});

  @override
  List<Object> get props => [partite, infoGruppi];

  @override
  String toString() =>
      'HomeSuccess(partite: $partite, infoGruppi: $infoGruppi)';

  HomeSuccess copyWith(
      {List<Partita>? partite, List<Gruppo>? infoGruppi, OrderBy? orderBy}) {
    return HomeSuccess(
      partite: partite ?? this.partite,
      infoGruppi: infoGruppi ?? this.infoGruppi,
      orderBy: orderBy ?? this.orderBy,
    );
  }
}