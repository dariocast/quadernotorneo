part of 'dettaglio_bloc.dart';

abstract class DettaglioState extends Equatable {
  const DettaglioState();

  @override
  List<Object> get props => [];
}

class DettaglioInitial extends DettaglioState {}

class DettaglioSaved extends DettaglioState {}

class DettaglioEdited extends DettaglioState {}
