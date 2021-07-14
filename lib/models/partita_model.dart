import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'models.dart';

class PartitaModel extends Equatable {
  final int id;
  final String squadraUno;
  final String squadraDue;
  final int golSquadraUno;
  final int falliSquadraUno;
  final int golSquadraDue;
  final int falliSquadraDue;
  final List<Giocatore> marcatori;
  final List<Giocatore> ammoniti;
  final List<Giocatore> espulsi;
  final DateTime data;

  const PartitaModel({
    required this.id,
    required this.squadraUno,
    required this.squadraDue,
    required this.golSquadraUno,
    required this.falliSquadraUno,
    required this.golSquadraDue,
    required this.falliSquadraDue,
    required this.marcatori,
    required this.ammoniti,
    required this.espulsi,
    required this.data,
  });
  PartitaModel.empty()
      : this(
          id: 0,
          squadraUno: '',
          squadraDue: '',
          golSquadraUno: 0,
          falliSquadraUno: 0,
          golSquadraDue: 0,
          falliSquadraDue: 0,
          marcatori: List.empty(),
          ammoniti: List.empty(),
          espulsi: List.empty(),
          data: DateTime.now(),
        );

  @override
  List<Object> get props => [
        id,
        squadraUno,
        squadraDue,
        golSquadraUno,
        falliSquadraUno,
        golSquadraDue,
        falliSquadraDue,
        marcatori,
        ammoniti,
        espulsi,
        data,
      ];

  @override
  String toString() =>
      'Partita { id: $id, squadraUno: $squadraUno, squadraDue: $squadraDue }';

  PartitaModel copyWith({
    int? id,
    String? squadraUno,
    String? squadraDue,
    int? golSquadraUno,
    int? falliSquadraUno,
    int? golSquadraDue,
    int? falliSquadraDue,
    List<Giocatore>? marcatori,
    List<Giocatore>? ammoniti,
    List<Giocatore>? espulsi,
    DateTime? data,
  }) {
    return PartitaModel(
      id: id ?? this.id,
      squadraUno: squadraUno ?? this.squadraUno,
      squadraDue: squadraDue ?? this.squadraDue,
      golSquadraUno: golSquadraUno ?? this.golSquadraUno,
      falliSquadraUno: falliSquadraUno ?? this.falliSquadraUno,
      golSquadraDue: golSquadraDue ?? this.golSquadraDue,
      falliSquadraDue: falliSquadraDue ?? this.falliSquadraDue,
      marcatori: marcatori ?? this.marcatori,
      ammoniti: ammoniti ?? this.ammoniti,
      espulsi: espulsi ?? this.espulsi,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'squadraUno': squadraUno,
      'squadraDue': squadraDue,
      'golSquadraUno': golSquadraUno,
      'falliSquadraUno': falliSquadraUno,
      'golSquadraDue': golSquadraDue,
      'falliSquadraDue': falliSquadraDue,
      'marcatori': marcatori.map((x) => x.toMap()).toList(),
      'ammoniti': ammoniti.map((x) => x.toMap()).toList(),
      'espulsi': espulsi.map((x) => x.toMap()).toList(),
      'data': data.millisecondsSinceEpoch / 1000
    };
  }

  factory PartitaModel.fromMap(Map<String, dynamic> map) {
    return PartitaModel(
      id: map['_id'],
      squadraUno: map['squadraUno'],
      squadraDue: map['squadraDue'],
      golSquadraUno: map['golSquadraUno'],
      falliSquadraUno: map['falliSquadraUno'],
      golSquadraDue: map['golSquadraDue'],
      falliSquadraDue: map['falliSquadraDue'],
      marcatori: List<Giocatore>.from(
          map['marcatori']?.map((x) => Giocatore.fromMap(x))),
      ammoniti: List<Giocatore>.from(
          map['ammoniti']?.map((x) => Giocatore.fromMap(x))),
      espulsi: List<Giocatore>.from(
          map['espulsi']?.map((x) => Giocatore.fromMap(x))),
      data: DateTime.fromMillisecondsSinceEpoch(map['data'] * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory PartitaModel.fromJson(String source) =>
      PartitaModel.fromMap(json.decode(source));
}
