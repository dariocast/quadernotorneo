part of 'tornei_bloc.dart';

abstract class TorneiEvent extends Equatable {
  const TorneiEvent();

  @override
  List<Object> get props => [];
}

class TorneiLoaded extends TorneiEvent {}

class TorneiCrea extends TorneiEvent {
  final String nome;
  TorneiCrea({
    required this.nome,
  });

  List<Object> get props => [nome];
}

class TorneiAggiorna extends TorneiEvent {
  final Torneo torneo;
  TorneiAggiorna({
    required this.torneo,
  });

  List<Object> get props => [torneo];
}
