part of 'gruppi_bloc.dart';

abstract class GruppiEvent extends Equatable {
  const GruppiEvent();

  @override
  List<Object> get props => [];
}

class GruppiLoaded extends GruppiEvent {}

class GruppiCrea extends GruppiEvent {
  final String nome;
  final String girone;
  final String logo;
  const GruppiCrea(this.nome, this.girone, this.logo);
}

class GruppiElimina extends GruppiEvent {
  final int id;

  const GruppiElimina(this.id);
}

class GruppiAggiorna extends GruppiEvent {
  final Gruppo aggiornato;

  const GruppiAggiorna(this.aggiornato);
}
