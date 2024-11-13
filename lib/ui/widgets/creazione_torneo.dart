import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/tornei/tornei_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';

class WidgetCreazioneTorneo extends StatefulWidget {
  final Torneo? torneo;

  const WidgetCreazioneTorneo({
    super.key,
    this.torneo,
  });

  @override
  State<WidgetCreazioneTorneo> createState() => _WidgetCreazioneTorneoState();
}

class _WidgetCreazioneTorneoState extends State<WidgetCreazioneTorneo> {
  String? name;

  @override
  void initState() {
    if (widget.torneo != null) {
      name = widget.torneo!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  widget.torneo != null
                      ? AppLocalizations.of(context)!.tournamentWidgetEditTitle
                      : AppLocalizations.of(context)!.tournamentWidgetNewTitle,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  initialValue: name,
                  onChanged: (value) => setState(() {
                    name = value;
                  }),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context)!.tournamentWidgetNameLabel,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Center(
                    child: Text('Annulla'),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (name != null) {
                      final torneoUpdated = widget.torneo?.copyWith(
                        name: name,
                      );
                      if (torneoUpdated != null) {
                        context.read<TorneiBloc>().add(TorneiAggiorna(
                              torneo: torneoUpdated,
                            ));
                      } else {
                        context.read<TorneiBloc>().add(TorneiCrea(
                              nome: name!.trim(),
                            ));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Center(
                    child: Text(widget.torneo != null
                        ? AppLocalizations.of(context)!
                            .tournamentWidgetEditButtonTitle
                        : AppLocalizations.of(context)!
                            .tournamentWidgetNewButtonTitle),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
