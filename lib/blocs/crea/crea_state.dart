part of 'crea_bloc.dart';

class CreaState extends Equatable {
  final List<String>? gruppi;
  final String? gruppoUno;
  final String? gruppoDue;
  final DateTime? data;
  final TimeOfDay? orario;
  final bool isLoading;
  final bool isValid;
  final bool creationSuccess;
  const CreaState({
    this.gruppi,
    this.gruppoUno,
    this.gruppoDue,
    this.data,
    this.orario,
    this.isLoading = true,
    this.isValid = false,
    this.creationSuccess = false,
  });

  @override
  List<Object?> get props {
    return [
      gruppi,
      gruppoUno,
      gruppoDue,
      data,
      orario,
      isLoading,
      isValid,
      creationSuccess,
    ];
  }

  CreaState copyWith(
      {List<String>? gruppi,
      String? gruppoUno,
      String? gruppoDue,
      DateTime? data,
      TimeOfDay? orario,
      bool? isLoading,
      bool? isValid,
      bool? creationSuccess}) {
    return CreaState(
      gruppi: gruppi ?? this.gruppi,
      gruppoUno: gruppoUno ?? this.gruppoUno,
      gruppoDue: gruppoDue ?? this.gruppoDue,
      data: data ?? this.data,
      orario: orario ?? this.orario,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      creationSuccess: creationSuccess ?? this.creationSuccess,
    );
  }
}
