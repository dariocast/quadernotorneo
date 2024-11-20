import 'dart:convert';

import 'models.dart';

class Giocatore extends GiocatoreBase {
  final int id;
  final int gol;
  final int ammonizioni;
  final int espulsioni;
  final int image;
  final String? photo;
  Giocatore(nome, gruppo, this.id, this.gol, this.ammonizioni, this.espulsioni,
      this.image, this.photo)
      : super(nome, gruppo);

  @override
  List<Object> get props => [nome, gruppo, id, gol];

  @override
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'gruppo': gruppo,
      'id': id,
      'gol': gol,
      'ammonizioni': ammonizioni,
      'espulsioni': espulsioni,
      'image': image,
      'photo': photo,
    };
  }

  factory Giocatore.fromMap(Map<String, dynamic> map) {
    return Giocatore(
      map['nome'],
      map['gruppo'],
      map['id'],
      map['gol'],
      map['ammonizioni'],
      map['espulsioni'],
      map['image'],
      map['photo'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Giocatore.fromJson(String source) =>
      Giocatore.fromMap(json.decode(source));

  @override
  Giocatore copyWith({
    String? nome,
    String? gruppo,
    int? id,
    int? gol,
    int? ammonizioni,
    int? espulsioni,
    int? image,
    String? photo,
  }) {
    return Giocatore(
      nome ?? this.nome,
      gruppo ?? this.gruppo,
      id ?? this.id,
      gol ?? this.gol,
      ammonizioni ?? this.ammonizioni,
      espulsioni ?? this.espulsioni,
      image ?? this.image,
      photo ?? this.photo,
    );
  }
}
