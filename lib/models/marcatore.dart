import 'dart:convert';

import 'package:equatable/equatable.dart';

class Marcatore extends Equatable {
  final String nome;
  final String gruppo;

  Marcatore(this.nome, this.gruppo);

  @override
  List<Object> get props => [nome, gruppo];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'gruppo': gruppo,
    };
  }

  factory Marcatore.fromMap(Map<String, dynamic> map) {
    return Marcatore(
      map['nome'],
      map['gruppo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Marcatore.fromJson(String source) =>
      Marcatore.fromMap(json.decode(source));

  Marcatore copyWith({
    String? nome,
    String? gruppo,
  }) {
    return Marcatore(
      nome ?? this.nome,
      gruppo ?? this.gruppo,
    );
  }
}
