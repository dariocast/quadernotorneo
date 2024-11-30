part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final String? locale;

  const SettingsLoaded({this.locale});

  @override
  List<Object> get props => [locale ?? ''];
}
