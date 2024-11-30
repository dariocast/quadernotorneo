import 'dart:ui'; // For PlatformDispatcher
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../database.dart';
import '../../utils/log_helper.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    QTLog.log('SettingsBloc initialized', name: 'bloc.settings');
    on<SettingsLocaleChanged>(_onSettingsLocaleChanged);
    _loadInitialSettings();
  }

  // Handle the SettingsLocaleChanged event
  Future<void> _onSettingsLocaleChanged(
      SettingsLocaleChanged event, Emitter<SettingsState> emit) async {
    QTLog.log('Locale change requested: ${event.locale}',
        name: 'bloc.settings');
    emit(SettingsLoaded(locale: event.locale));
    await Database.put('locale', event.locale);
    QTLog.log('Locale saved to database: ${event.locale}',
        name: 'bloc.settings');
  }

  // Load initial settings from the database or use system locale if none exists
  Future<void> _loadInitialSettings() async {
    QTLog.log('Loading initial settings from database', name: 'bloc.settings');
    final locale = await Database.get('locale');
    if (locale != null) {
      QTLog.log('Locale found in database: $locale', name: 'bloc.settings');
      add(SettingsLocaleChanged(locale));
    } else {
      // Get system locale using PlatformDispatcher
      final systemLocale =
          PlatformDispatcher.instance.locales.first.languageCode;
      QTLog.log(
          'No locale found in database, using system locale: $systemLocale',
          name: 'bloc.settings');
      await Database.put('locale', systemLocale); // Save system locale to DB
      add(SettingsLocaleChanged(systemLocale));
    }
  }
}
