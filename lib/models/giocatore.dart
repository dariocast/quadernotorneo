import 'dart:convert';

import 'package:equatable/equatable.dart';

class Giocatore extends Equatable {
  final String nome;
  final String gruppo;
  final int? id;
  final int? gol;
  Giocatore(this.nome, this.gruppo, this.id, this.gol);

  @override
  List<Object?> get props => [nome, gruppo, id, gol];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'gruppo': gruppo,
      '_id': id,
      'gol': gol,
    };
  }

  factory Giocatore.fromMap(Map<String, dynamic> map) {
    return Giocatore(
      map['nome'],
      map['gruppo'],
      map['_id'],
      map['gol'],
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
  }) {
    return Giocatore(
      nome ?? this.nome,
      gruppo ?? this.gruppo,
      id ?? this.id,
      gol ?? this.gol,
    );
  }
}
