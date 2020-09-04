import 'package:equatable/equatable.dart';

class PartitaModel extends Equatable {
  final int id;
  final String squadra1;
  final String squadra2;
  final int golSquadra1;
  final int golSquadra2;
  final List marcatori;
  final List ammoniti;
  final List espulsi;

  PartitaModel(
      {this.id,
      this.squadra1,
      this.squadra2,
      this.golSquadra1,
      this.golSquadra2,
      this.marcatori,
      this.ammoniti,
      this.espulsi});

  factory PartitaModel.fromJson(Map<String, dynamic> json) {
    return PartitaModel(
      id: json['_id'] as int,
      squadra1: json['squadraUno'] as String,
      squadra2: json['squadraDue'] as String,
      golSquadra1: json['golSquadraUno'] as int,
      golSquadra2: json['golSquadraDue'] as int,
      marcatori: json['marcatori'] as List,
      ammoniti: json['ammoniti'] as List,
      espulsi: json['espulsi'] as List,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'squadraUno': squadra1,
        'squadraDue': squadra2,
        'golSquadraUno': golSquadra1,
        'golSquadraDue': golSquadra2,
        'marcatori': marcatori,
        'ammoniti': ammoniti,
        'espulsi': espulsi
      };

  @override
  List<Object> get props => [
        id,
        squadra1,
        squadra2,
        golSquadra1,
        golSquadra2,
        marcatori,
        ammoniti,
        espulsi
      ];

  @override
  String toString() =>
      'Partita { id: $id, squadra1: $squadra1, squadra2: $squadra2 }';
}
