part of 'crea_bloc.dart';

class CreaState extends Equatable {
  final List<String>? gruppi;
  final String? gruppoUno;
  final String? gruppoDue;
  final DateTime? data;
  final TimeOfDay? orario;
  final String? descrizione;
  final String torneo;
  final bool hasGruppi;
  final bool isLoading;
  final bool isValid;
  final bool creationSuccess;
  const CreaState({
    this.gruppi,
    this.gruppoUno,
    this.gruppoDue,
    this.data,
    this.orario,
    this.hasGruppi = false,
    this.isLoading = true,
    this.isValid = false,
    this.creationSuccess = false,
    this.descrizione = '',
    this.torneo = '',
  });

  @override
  List<Object?> get props {
    return [
      gruppi,
      gruppoUno,
      gruppoDue,
      data,
      orario,
      hasGruppi,
      isLoading,
      isValid,
      creationSuccess,
      descrizione,
      torneo,
    ];
  }

  CreaState copyWith({
    List<String>? gruppi,
    String? gruppoUno,
    String? gruppoDue,
    DateTime? data,
    TimeOfDay? orario,
    bool? hasGruppi,
    bool? isLoading,
    bool? isValid,
    bool? creationSuccess,
    String? descrizione,
    String? torneo,
  }) {
    return CreaState(
      gruppi: gruppi ?? this.gruppi,
      gruppoUno: gruppoUno ?? this.gruppoUno,
      gruppoDue: gruppoDue ?? this.gruppoDue,
      data: data ?? this.data,
      orario: orario ?? this.orario,
      hasGruppi: hasGruppi ?? this.hasGruppi,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      creationSuccess: creationSuccess ?? this.creationSuccess,
      descrizione: descrizione ?? this.descrizione,
      torneo: torneo ?? this.torneo,
    );
  }
}
