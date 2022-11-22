import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? username;
  final String? fullname;
  final String? avatarUrl;
  final bool isAdmin;
  const User({
    required this.id,
    this.username,
    this.fullname,
    this.avatarUrl,
    required this.isAdmin,
  });

  @override
  List<Object?> get props {
    return [
      id,
      username,
      fullname,
      avatarUrl,
      isAdmin,
    ];
  }

  static const empty = User(
      id: '-', isAdmin: false, username: null, avatarUrl: null, fullname: null);

  User copyWith({
    String? id,
    String? username,
    String? fullname,
    String? avatarUrl,
    bool? isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'full_name': fullname,
      'avatar_url': avatarUrl,
      'admin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'],
      fullname: map['full_name'],
      avatarUrl: map['avatar_url'],
      isAdmin: map['admin'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, username: $username, fullname: $fullname, avatarUrl: $avatarUrl, isAdmin: $isAdmin)';
  }
}
