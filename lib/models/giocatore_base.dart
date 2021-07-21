import 'dart:convert';

import 'package:equatable/equatable.dart';

class GiocatoreBase extends Equatable {
  final String nome;
  final String gruppo;

  GiocatoreBase(this.nome, this.gruppo);

  @override
  List<Object> get props => [nome, gruppo];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'gruppo': gruppo,
    };
  }

  factory GiocatoreBase.fromMap(Map<String, dynamic> map) {
    return GiocatoreBase(
      map['nome'],
      map['gruppo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GiocatoreBase.fromJson(String source) =>
      GiocatoreBase.fromMap(json.decode(source));

  GiocatoreBase copyWith({
    String? nome,
    String? gruppo,
  }) {
    return GiocatoreBase(
      nome ?? this.nome,
      gruppo ?? this.gruppo,
    );
  }
}
