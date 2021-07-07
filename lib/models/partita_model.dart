import 'dart:convert';

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

  const PartitaModel({
    required this.id,
    required this.squadra1,
    required this.squadra2,
    required this.golSquadra1,
    required this.golSquadra2,
    required this.marcatori,
    required this.ammoniti,
    required this.espulsi,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'squadra1': squadra1,
      'squadra2': squadra2,
      'golSquadra1': golSquadra1,
      'golSquadra2': golSquadra2,
      'marcatori': marcatori,
      'ammoniti': ammoniti,
      'espulsi': espulsi,
    };
  }

  factory PartitaModel.fromMap(Map<String, dynamic> map) {
    return PartitaModel(
      id: map['_id'],
      squadra1: map['squadraUno'],
      squadra2: map['squadraDue'],
      golSquadra1: map['golSquadraUno'],
      golSquadra2: map['golSquadraDue'],
      marcatori: List.from(map['marcatori']),
      ammoniti: List.from(map['ammoniti']),
      espulsi: List.from(map['espulsi']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PartitaModel.fromJson(String source) =>
      PartitaModel.fromMap(json.decode(source));
}
