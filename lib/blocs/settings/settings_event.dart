part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class SettingsLocaleChanged extends SettingsEvent {
  final String locale;

  const SettingsLocaleChanged(this.locale);

  @override
  List<Object> get props => [locale];
}
