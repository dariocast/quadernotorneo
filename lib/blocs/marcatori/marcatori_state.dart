part of 'marcatori_bloc.dart';

abstract class MarcatoriState extends Equatable {
  const MarcatoriState();

  @override
  List<Object> get props => [];
}

class MarcatoriInitial extends MarcatoriState {}

class MarcatoriLoadFailure extends MarcatoriState {}

class MarcatoriLoading extends MarcatoriState {}

class MarcatoriLoadSuccess extends MarcatoriState {
  final List<Giocatore> marcatori;
  final Map<String, String> loghi;

  const MarcatoriLoadSuccess(this.marcatori, this.loghi);
}
