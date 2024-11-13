import 'package:equatable/equatable.dart';

class Evento extends Equatable {
  final String nome;
  final String squadra;
  final TipoEvento tipo;

  const Evento(this.nome, this.squadra, this.tipo);

  @override
  List<Object> get props => [nome, squadra, tipo];

  Evento copyWith({
    String? nome,
    String? squadra,
    TipoEvento? tipo,
  }) {
    return Evento(
      nome ?? this.nome,
      squadra ?? this.squadra,
      tipo ?? this.tipo,
    );
  }
}

enum TipoEvento {
  GOL,
  AUTOGOL,
  AMMONIZIONE,
  ESPULSIONE,
  FALLO,
}
