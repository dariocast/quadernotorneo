import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';

class ClassificaGironeCard extends StatelessWidget {
  const ClassificaGironeCard(
    this.title,
    this.gruppi, {
    super.key,
  });

  final String title;
  final List<Gruppo> gruppi;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(8.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _headerRow(context),
            _rows(context),
          ],
        ),
      ),
    );
  }

  Widget _headerRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${AppLocalizations.of(context)!.groupLabel} ${title.toUpperCase()}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        _headerItem(context,
            AppLocalizations.of(context)!.leaderboardsPlayedColumnHeader),
        _headerItem(context,
            AppLocalizations.of(context)!.leaderboardsWinsColumnHeader),
        _headerItem(context,
            AppLocalizations.of(context)!.leaderboardsDrawsColumnHeader),
        _headerItem(context,
            AppLocalizations.of(context)!.leaderboardsLossesColumnHeader),
        _headerItem(context,
            AppLocalizations.of(context)!.leaderboardsPointsColumnHeader),
      ],
    );
  }

  Widget _headerItem(BuildContext context, String text) {
    return SizedBox(
      width: 20,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Column _rows(BuildContext context) {
    List<Widget> rows = gruppi.map((gruppo) => _row(context, gruppo)).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: rows,
    );
  }

  Widget _row(BuildContext context, Gruppo gruppo) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: 50.0, height: 50.0, child: Image.network(gruppo.logo)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              gruppo.nome,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        _rowData(context, gruppo.pg.toString()),
        _rowData(context, gruppo.v.toString()),
        _rowData(context, gruppo.p.toString()),
        _rowData(context, gruppo.s.toString()),
        _rowData(context, gruppo.pt.toString()),
      ],
    );
  }

  Widget _rowData(BuildContext context, String text) {
    return SizedBox(
      width: 20,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
