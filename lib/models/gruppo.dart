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
  final List<int> ultime;

  Gruppo(this.nome, this.girone, this.logo, this.id, this.pg, this.v, this.p,
      this.s, this.gf, this.gs, this.pt, this.ultime);

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
      ultime,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'girone': girone,
      'logo': logo,
      '_id': id,
      'pg': pg,
      'v': v,
      'p': p,
      's': s,
      'gf': gf,
      'gs': gs,
      'pt': pt,
      'ultime': ultime,
    };
  }

  factory Gruppo.fromMap(Map<String, dynamic> map) {
    return Gruppo(
      map['nome'],
      map['girone'],
      map['logo'],
      map['_id'],
      map['pg'],
      map['v'],
      map['p'],
      map['s'],
      map['gf'],
      map['gs'],
      map['pt'],
      List<int>.from(map['ultime']),
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
    List<int>? ultime,
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
      ultime ?? this.ultime,
    );
  }
}
