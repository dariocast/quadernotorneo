part of 'dettaglio_bloc.dart';

class DettaglioState extends Equatable {
  final PartitaModel? partita;
  final List<String>? giocatoriSquadraUno;
  final List<String>? giocatoriSquadraDue;
  final List<Evento>? eventi;
  final bool loading;
  final bool isEdit;
  const DettaglioState({
    this.partita,
    this.giocatoriSquadraUno,
    this.giocatoriSquadraDue,
    this.eventi,
    this.loading = true,
    this.isEdit = false,
  });

  @override
  List<Object?> get props {
    return [
      partita,
      giocatoriSquadraUno,
      giocatoriSquadraDue,
      eventi,
      loading,
      isEdit,
    ];
  }

  DettaglioState copyWith({
    PartitaModel? partita,
    List<String>? giocatoriSquadraUno,
    List<String>? giocatoriSquadraDue,
    List<Evento>? eventi,
    bool? loading,
    bool? isEdit,
  }) {
    return DettaglioState(
      partita: partita ?? this.partita,
      giocatoriSquadraUno: giocatoriSquadraUno ?? this.giocatoriSquadraUno,
      giocatoriSquadraDue: giocatoriSquadraDue ?? this.giocatoriSquadraDue,
      eventi: eventi ?? this.eventi,
      loading: loading ?? this.loading,
      isEdit: isEdit ?? this.isEdit,
    );
  }
}
