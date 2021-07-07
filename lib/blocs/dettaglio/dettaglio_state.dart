part of 'dettaglio_bloc.dart';

class DettaglioState extends Equatable {
  final PartitaModel? partita;
  final bool loading;
  final bool isEdit;
  const DettaglioState({
    this.partita,
    this.loading = true,
    this.isEdit = false,
  });

  @override
  List<Object?> get props => [partita, loading];

  DettaglioState copyWith({
    PartitaModel? partita,
    bool? loading,
    bool? isEdit,
  }) {
    return DettaglioState(
      partita: partita ?? this.partita,
      loading: loading ?? this.loading,
      isEdit: isEdit ?? this.isEdit,
    );
  }
}
