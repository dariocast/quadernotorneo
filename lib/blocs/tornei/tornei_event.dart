part of 'tornei_bloc.dart';

abstract class TorneiEvent extends Equatable {
  const TorneiEvent();

  @override
  List<Object> get props => [];
}

class TorneiLoaded extends TorneiEvent {}

class TorneiCrea extends TorneiEvent {
  final String nome;
  const TorneiCrea({
    required this.nome,
  });

  @override
  List<Object> get props => [nome];
}

class TorneiAggiorna extends TorneiEvent {
  final Torneo torneo;
  const TorneiAggiorna({
    required this.torneo,
  });

  @override
  List<Object> get props => [torneo];
}

class TorneiElimina extends TorneiEvent {
  final Torneo torneo;
  const TorneiElimina({
    required this.torneo,
  });

  @override
  List<Object> get props => [torneo];
}

class TorneoSelezionato extends TorneiEvent {
  final Torneo torneo;
  const TorneoSelezionato({
    required this.torneo,
  });

  @override
  List<Object> get props => [torneo];
}
