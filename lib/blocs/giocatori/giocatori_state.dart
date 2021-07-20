part of 'giocatori_bloc.dart';

abstract class GiocatoriState extends Equatable {
  const GiocatoriState();

  @override
  List<Object> get props => [];
}

class GiocatoriInitial extends GiocatoriState {}

class GiocatoriLoading extends GiocatoriState {}

class GiocatoriLoadSuccess extends GiocatoriState {
  final List<Giocatore> giocatori;

  GiocatoriLoadSuccess(this.giocatori);
}

class GiocatoriLoadFailure extends GiocatoriState {
  final String message;

  GiocatoriLoadFailure(this.message);
}
