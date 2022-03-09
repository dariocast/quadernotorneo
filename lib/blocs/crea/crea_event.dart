part of 'crea_bloc.dart';

abstract class CreaEvent extends Equatable {
  const CreaEvent();

  @override
  List<Object> get props => [];
}

class CreaLoaded extends CreaEvent {}

class CreaGruppoUnoChanged extends CreaEvent {
  final String gruppo;

  CreaGruppoUnoChanged(this.gruppo);
}

class CreaGruppoDueChanged extends CreaEvent {
  final String gruppo;

  CreaGruppoDueChanged(this.gruppo);
}

class CreaDataChanged extends CreaEvent {
  final DateTime data;

  CreaDataChanged(this.data);
}

class CreaOrarioChanged extends CreaEvent {
  final TimeOfDay orario;

  CreaOrarioChanged(this.orario);
}

class CreaDescrizioneChanged extends CreaEvent {
  final String descrizione;

  CreaDescrizioneChanged(this.descrizione);
}

class CreaSubmit extends CreaEvent {}
