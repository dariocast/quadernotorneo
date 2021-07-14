part of 'drawer_cubit.dart';

class DrawerState extends Equatable {
  final bool loading;
  final bool updateClassificaSuccess;
  final bool updateMarcatoriSuccess;

  const DrawerState({
    this.loading = false,
    this.updateClassificaSuccess = false,
    this.updateMarcatoriSuccess = false,
  });

  @override
  List<Object?> get props => [
        loading,
        updateClassificaSuccess,
        updateMarcatoriSuccess,
      ];

  DrawerState copyWith({
    bool? loading,
    bool? updateClassificaSuccess,
    bool? updateMarcatoriSuccess,
  }) {
    return DrawerState(
      loading: loading ?? this.loading,
      updateClassificaSuccess:
          updateClassificaSuccess ?? this.updateClassificaSuccess,
      updateMarcatoriSuccess:
          updateMarcatoriSuccess ?? this.updateMarcatoriSuccess,
    );
  }
}
