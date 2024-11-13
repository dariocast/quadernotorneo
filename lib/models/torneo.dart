import 'dart:convert';

import 'package:equatable/equatable.dart';

class Torneo extends Equatable {
  final int id;
  final String name;

  const Torneo({
    required this.id,
    required this.name,
  });

  Torneo copyWith({
    int? id,
    String? name,
  }) {
    return Torneo(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Torneo.fromMap(Map<String, dynamic> map) {
    return Torneo(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Torneo.fromJson(String source) => Torneo.fromMap(json.decode(source));

  @override
  String toString() => 'Torneo(id: $id, name: $name)';

  @override
  List<Object> get props => [id, name];
}
