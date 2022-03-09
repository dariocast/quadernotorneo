import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'models.dart';

class Partita extends Equatable {
  final int id;
  final String squadraUno;
  final String squadraDue;
  final int golSquadraUno;
  final int falliSquadraUno;
  final int golSquadraDue;
  final int falliSquadraDue;
  final List<GiocatoreBase> marcatori;
  final List<GiocatoreBase> ammoniti;
  final List<GiocatoreBase> espulsi;
  final DateTime data;
  final String descrizione;

  const Partita({
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
    required this.descrizione,
  });
  Partita.empty()
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
          descrizione: '',
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
        descrizione,
      ];

  Partita copyWith({
    int? id,
    String? squadraUno,
    String? squadraDue,
    int? golSquadraUno,
    int? falliSquadraUno,
    int? golSquadraDue,
    int? falliSquadraDue,
    List<GiocatoreBase>? marcatori,
    List<GiocatoreBase>? ammoniti,
    List<GiocatoreBase>? espulsi,
    DateTime? data,
    String? descrizione,
  }) {
    return Partita(
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
      descrizione: descrizione ?? this.descrizione,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'squadraUno': squadraUno,
      'squadraDue': squadraDue,
      'golSquadraUno': golSquadraUno,
      'falliSquadraUno': falliSquadraUno,
      'golSquadraDue': golSquadraDue,
      'falliSquadraDue': falliSquadraDue,
      'marcatori': marcatori.map((x) => x.toMap()).toList(),
      'ammoniti': ammoniti.map((x) => x.toMap()).toList(),
      'espulsi': espulsi.map((x) => x.toMap()).toList(),
      'data': data.toIso8601String(),
      'descrizione': descrizione,
    };
  }

  factory Partita.fromMap(Map<String, dynamic> map) {
    return Partita(
      id: map['id']?.toInt() ?? 0,
      squadraUno: map['squadraUno'] ?? '',
      squadraDue: map['squadraDue'] ?? '',
      golSquadraUno: map['golSquadraUno']?.toInt() ?? 0,
      falliSquadraUno: map['falliSquadraUno']?.toInt() ?? 0,
      golSquadraDue: map['golSquadraDue']?.toInt() ?? 0,
      falliSquadraDue: map['falliSquadraDue']?.toInt() ?? 0,
      marcatori: List<GiocatoreBase>.from(
          map['marcatori']?.map((x) => GiocatoreBase.fromJson(x))),
      ammoniti: List<GiocatoreBase>.from(
          map['ammoniti']?.map((x) => GiocatoreBase.fromJson(x))),
      espulsi: List<GiocatoreBase>.from(
          map['espulsi']?.map((x) => GiocatoreBase.fromJson(x))),
      data: DateTime.parse((map['data'])),
      descrizione: map['descrizione'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Partita.fromJson(String source) =>
      Partita.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Partita(id: $id, squadraUno: $squadraUno, squadraDue: $squadraDue, golSquadraUno: $golSquadraUno, falliSquadraUno: $falliSquadraUno, golSquadraDue: $golSquadraDue, falliSquadraDue: $falliSquadraDue, marcatori: $marcatori, ammoniti: $ammoniti, espulsi: $espulsi, data: $data, descrizione: $descrizione)';
  }
}
