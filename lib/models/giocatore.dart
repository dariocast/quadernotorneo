import 'dart:convert';

import 'package:equatable/equatable.dart';

class Giocatore extends Equatable {
  final String giocatore;
  final String squadra;

  Giocatore(this.giocatore, this.squadra);

  @override
  List<Object> get props => [giocatore, squadra];

  Map<String, dynamic> toMap() {
    return {
      'giocatore': giocatore,
      'squadra': squadra,
    };
  }

  factory Giocatore.fromMap(Map<String, dynamic> map) {
    return Giocatore(
      map['giocatore'],
      map['squadra'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Giocatore.fromJson(String source) =>
      Giocatore.fromMap(json.decode(source));

  Giocatore copyWith({
    String? giocatore,
    String? squadra,
  }) {
    return Giocatore(
      giocatore ?? this.giocatore,
      squadra ?? this.squadra,
    );
  }
}
