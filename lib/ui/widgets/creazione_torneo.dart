import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/tornei/tornei_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';

class WidgetCreazioneTorneo extends StatefulWidget {
  final Torneo? torneo;

  const WidgetCreazioneTorneo({
    Key? key,
    this.torneo,
  }) : super(key: key);

  @override
  State<WidgetCreazioneTorneo> createState() =>
      _WidgetParametriGiocatoreState();
}

class _WidgetParametriGiocatoreState extends State<WidgetCreazioneTorneo> {
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
                  initialValue: this.name,
                  onChanged: (value) => setState(() {
                    this.name = value;
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
                    if (this.name != null) {
                      final torneoUpdated = widget.torneo?.copyWith(
                            name: this.name,
                          ) ??
                          null;
                      if (torneoUpdated != null) {
                        context.read<TorneiBloc>().add(TorneiAggiorna(
                              torneo: torneoUpdated,
                            ));
                      } else {
                        context.read<TorneiBloc>().add(TorneiCrea(
                              nome: this.name!.trim(),
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
