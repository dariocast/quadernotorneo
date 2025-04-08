part of 'gruppi_bloc.dart';

abstract class GruppiState extends Equatable {
  const GruppiState();

  @override
  List<Object> get props => [];
}

class GruppiInitial extends GruppiState {}

class GruppiLoading extends GruppiState {}

class GruppiLoadSuccess extends GruppiState {
  final List<Gruppo> gruppi;

  const GruppiLoadSuccess(this.gruppi);
}

class GruppiLoadFailure extends GruppiState {
  final String message;

  const GruppiLoadFailure(this.message);
}
