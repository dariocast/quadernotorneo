part of 'giocatori_bloc.dart';

abstract class GiocatoriEvent extends Equatable {
  const GiocatoriEvent();

  @override
  List<Object> get props => [];
}

class GiocatoriLoaded extends GiocatoriEvent {}

class GiocatoriCrea extends GiocatoriEvent {
  final String nome;
  final String gruppo;

  GiocatoriCrea(this.nome, this.gruppo);
}

class GiocatoriElimina extends GiocatoriEvent {
  final int id;

  GiocatoriElimina(this.id);
}

class GiocatoriAggiorna extends GiocatoriEvent {
  final Giocatore aggiornato;

  GiocatoriAggiorna(this.aggiornato);
}
