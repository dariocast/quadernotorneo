import 'dart:convert';

import 'package:quaderno_flutter/models/models.dart';

class Giocatore extends GiocatoreBase {
  final int id;
  final int gol;
  final int ammonizioni;
  final int espulsioni;
  Giocatore(nome, gruppo, this.id, this.gol, this.ammonizioni, this.espulsioni)
      : super(nome, gruppo);

  @override
  List<Object> get props => [nome, gruppo, id, gol];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'gruppo': gruppo,
      '_id': id,
      'gol': gol,
      'ammonizioni': ammonizioni,
      'espulsioni': espulsioni,
    };
  }

  factory Giocatore.fromMap(Map<String, dynamic> map) {
    return Giocatore(
      map['nome'],
      map['gruppo'],
      map['_id'],
      map['gol'],
      map['ammonizioni'],
      map['espulsioni'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Giocatore.fromJson(String source) =>
      Giocatore.fromMap(json.decode(source));

  Giocatore copyWith({
    String? nome,
    String? gruppo,
    int? id,
    int? gol,
    int? ammonizioni,
    int? espulsioni,
  }) {
    return Giocatore(
      nome ?? this.nome,
      gruppo ?? this.gruppo,
      id ?? this.id,
      gol ?? this.gol,
      ammonizioni ?? this.ammonizioni,
      espulsioni ?? this.espulsioni,
    );
  }
}
