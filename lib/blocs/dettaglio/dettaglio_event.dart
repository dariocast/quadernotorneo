part of 'dettaglio_bloc.dart';

abstract class DettaglioEvent extends Equatable {
  const DettaglioEvent();

  @override
  List<Object> get props => [];
}

class DettaglioLoaded extends DettaglioEvent {
  final Partita partita;

  const DettaglioLoaded(this.partita);
}

class DettaglioAmmonisci extends DettaglioEvent {
  final GiocatoreBase giocatore;

  const DettaglioAmmonisci(this.giocatore);
}

class DettaglioEspelli extends DettaglioEvent {
  final GiocatoreBase giocatore;

  const DettaglioEspelli(this.giocatore);
}

class DettaglioAggiungiGol extends DettaglioEvent {
  final GiocatoreBase giocatore;

  const DettaglioAggiungiGol(this.giocatore);
}

class DettaglioAggiungiAutogol extends DettaglioEvent {
  final GiocatoreBase giocatore;

  const DettaglioAggiungiAutogol(this.giocatore);
}

class DettaglioAggiungiFallo extends DettaglioEvent {
  final String squadra;

  const DettaglioAggiungiFallo(this.squadra);
}

class DettaglioRimuoviFallo extends DettaglioEvent {
  final String squadra;

  const DettaglioRimuoviFallo(this.squadra);
}

class DettaglioRimuoviPartita extends DettaglioEvent {}

class DettaglioSalvaPartita extends DettaglioEvent {}

class DettaglioUndo extends DettaglioEvent {}
