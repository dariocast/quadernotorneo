import 'dart:convert';

import 'package:equatable/equatable.dart';

class Gruppo extends Equatable {
  final String nome;
  final String girone;
  final String logo;
  final int id;
  final int pg;
  final int v;
  final int p;
  final int s;
  final int gf;
  final int gs;
  final int pt;

  const Gruppo(this.nome, this.girone, this.logo, this.id, this.pg, this.v,
      this.p, this.s, this.gf, this.gs, this.pt);

  @override
  List<Object> get props {
    return [
      nome,
      girone,
      logo,
      id,
      pg,
      v,
      p,
      s,
      gf,
      gs,
      pt,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'girone': girone,
      'logo': logo,
      'id': id,
      'pg': pg,
      'v': v,
      'p': p,
      's': s,
      'gf': gf,
      'gs': gs,
      'pt': pt,
    };
  }

  factory Gruppo.fromMap(Map<String, dynamic> map) {
    return Gruppo(
      map['nome'],
      map['girone'],
      map['logo'],
      map['id'],
      map['pg'],
      map['v'],
      map['p'],
      map['s'],
      map['gf'],
      map['gs'],
      map['pt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Gruppo.fromJson(String source) => Gruppo.fromMap(json.decode(source));

  Gruppo copyWith({
    String? nome,
    String? girone,
    String? logo,
    int? id,
    int? pg,
    int? v,
    int? p,
    int? s,
    int? gf,
    int? gs,
    int? pt,
  }) {
    return Gruppo(
      nome ?? this.nome,
      girone ?? this.girone,
      logo ?? this.logo,
      id ?? this.id,
      pg ?? this.pg,
      v ?? this.v,
      p ?? this.p,
      s ?? this.s,
      gf ?? this.gf,
      gs ?? this.gs,
      pt ?? this.pt,
    );
  }

  ordinaClassifica(Gruppo other) {
    return pt != other.pt
        ? pt.compareTo(other.pt)
        : (gf - gs).compareTo(other.gf - other.gs);
  }
}
