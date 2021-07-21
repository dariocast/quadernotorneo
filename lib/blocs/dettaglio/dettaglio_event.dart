part of 'dettaglio_bloc.dart';

abstract class DettaglioEvent extends Equatable {
  const DettaglioEvent();

  @override
  List<Object> get props => [];
}

class DettaglioLoaded extends DettaglioEvent {
  final PartitaModel partita;

  DettaglioLoaded(this.partita);
}

class DettaglioAmmonisci extends DettaglioEvent {
  final GiocatoreBase giocatore;

  DettaglioAmmonisci(this.giocatore);
}

class DettaglioEspelli extends DettaglioEvent {
  final GiocatoreBase giocatore;

  DettaglioEspelli(this.giocatore);
}

class DettaglioAggiungiGol extends DettaglioEvent {
  final GiocatoreBase giocatore;

  DettaglioAggiungiGol(this.giocatore);
}

class DettaglioAggiungiAutogol extends DettaglioEvent {
  final GiocatoreBase giocatore;

  DettaglioAggiungiAutogol(this.giocatore);
}

class DettaglioAggiungiFallo extends DettaglioEvent {
  final String squadra;

  DettaglioAggiungiFallo(this.squadra);
}

class DettaglioRimuoviFallo extends DettaglioEvent {
  final String squadra;

  DettaglioRimuoviFallo(this.squadra);
}

class DettaglioRimuoviPartita extends DettaglioEvent {}

class DettaglioSalvaPartita extends DettaglioEvent {}

class DettaglioUndo extends DettaglioEvent {}
