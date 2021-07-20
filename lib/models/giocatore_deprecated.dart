import 'dart:convert';

import 'package:equatable/equatable.dart';

@deprecated
class GiocatoreToRemove extends Equatable {
  final String nome;
  final String gruppo;

  GiocatoreToRemove(this.nome, this.gruppo);

  @override
  List<Object> get props => [nome, gruppo];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'gruppo': gruppo,
    };
  }

  factory GiocatoreToRemove.fromMap(Map<String, dynamic> map) {
    return GiocatoreToRemove(
      map['nome'],
      map['gruppo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GiocatoreToRemove.fromJson(String source) =>
      GiocatoreToRemove.fromMap(json.decode(source));

  GiocatoreToRemove copyWith({
    String? giocatore,
    String? squadra,
  }) {
    return GiocatoreToRemove(
      giocatore ?? this.nome,
      squadra ?? this.gruppo,
    );
  }
}
