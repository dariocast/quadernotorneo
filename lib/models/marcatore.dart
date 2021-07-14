import 'dart:convert';

import 'package:equatable/equatable.dart';

class Marcatore extends Equatable {
  final String nome;
  final String gruppo;
  final int? id;
  final int? gol;
  Marcatore(this.nome, this.gruppo, this.id, this.gol);

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

  factory Marcatore.fromMap(Map<String, dynamic> map) {
    return Marcatore(
      map['nome'],
      map['gruppo'],
      map['_id'],
      map['gol'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Marcatore.fromJson(String source) =>
      Marcatore.fromMap(json.decode(source));

  Marcatore copyWith({
    String? nome,
    String? gruppo,
    int? id,
    int? gol,
  }) {
    return Marcatore(
      nome ?? this.nome,
      gruppo ?? this.gruppo,
      id ?? this.id,
      gol ?? this.gol,
    );
  }
}
