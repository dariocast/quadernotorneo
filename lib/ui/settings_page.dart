import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';

class SettingsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (context) => const SettingsPage(),
    );
  }

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return _buildSettingsContent(context, state.locale);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, String? selectedLocale) {
    final locales = [
      {'label': 'English', 'value': 'en'},
      {'label': 'Italiano', 'value': 'it'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          AppLocalizations.of(context)!.languageSettingsLabel,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...locales.map((locale) {
          return RadioListTile<String>(
            title: Text(locale['label']!),
            value: locale['value']!,
            groupValue: selectedLocale,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(SettingsLocaleChanged(value));
              }
            },
          );
        }),
      ],
    );
  }
}
