part of 'partite_bloc.dart';

enum OrderBy { DATA_DESC, DATA_ASC, ID_DESC, ID_ASC }

abstract class PartiteState extends Equatable {
  const PartiteState();

  @override
  List<Object> get props => [];
}

class PartiteInitial extends PartiteState {}

class PartiteFailure extends PartiteState {}

class PartiteLoading extends PartiteState {}

class PartiteSuccess extends PartiteState {
  final List<Partita> partite;
  final List<Gruppo> infoGruppi;
  final OrderBy orderBy;

  const PartiteSuccess(
      {required this.partite, required this.infoGruppi, required this.orderBy});

  @override
  List<Object> get props => [partite, infoGruppi];

  @override
  String toString() =>
      'PartiteSuccess(partite: $partite, infoGruppi: $infoGruppi)';

  PartiteSuccess copyWith(
      {List<Partita>? partite, List<Gruppo>? infoGruppi, OrderBy? orderBy}) {
    return PartiteSuccess(
      partite: partite ?? this.partite,
      infoGruppi: infoGruppi ?? this.infoGruppi,
      orderBy: orderBy ?? this.orderBy,
    );
  }
}
