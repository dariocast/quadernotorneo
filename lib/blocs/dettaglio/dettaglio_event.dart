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
