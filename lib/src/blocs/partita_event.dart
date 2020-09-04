import 'package:equatable/equatable.dart';

abstract class PartitaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PartitaLoaded extends PartitaEvent {}
