import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/src/models/partita_model.dart';

abstract class PartitaState extends Equatable {
  const PartitaState();

  @override
  List<Object> get props => [];
}

class PartitaInitial extends PartitaState {}

class PartitaFailure extends PartitaState {}

class PartitaSuccess extends PartitaState {
  final List<PartitaModel> partite;

  const PartitaSuccess({this.partite});

  PartitaSuccess copyWith({
    List<PartitaModel> partite,
    bool hasReachedMax,
  }) {
    return PartitaSuccess(partite: partite ?? this.partite);
  }

  @override
  List<Object> get props => [partite];

  @override
  String toString() => 'PartitaSuccess { partite: ${partite.length}}';
}
