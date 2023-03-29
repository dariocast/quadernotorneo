import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';

class ClassificaGironeCard extends StatelessWidget {
  ClassificaGironeCard(
    this.title,
    this.gruppi, {
    Key? key,
  }) : super(key: key);

  final String title;
  final List<Gruppo> gruppi;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
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
      ),
    );
  }

  Widget _headerRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        SizedBox(
          width: 20,
          child: Text(
              AppLocalizations.of(context)!.leaderboardsPlayedColumnHeader),
        ),
        SizedBox(
          width: 20,
          child:
              Text(AppLocalizations.of(context)!.leaderboardsWinsColumnHeader),
        ),
        SizedBox(
          width: 20,
          child:
              Text(AppLocalizations.of(context)!.leaderboardsDrawsColumnHeader),
        ),
        SizedBox(
          width: 20,
          child: Text(
              AppLocalizations.of(context)!.leaderboardsLossesColumnHeader),
        ),
        SizedBox(
          width: 20,
          child: Text(
              AppLocalizations.of(context)!.leaderboardsPointsColumnHeader),
        ),
      ],
    );
  }

  Column _rows(BuildContext context) {
    List<Row> rows = [];
    for (var i = 0; i < gruppi.length; i++) {
      rows.add(_row(gruppi[i]));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: rows,
    );
  }

  Row _row(Gruppo gruppi) {
    return Row(
      children: [
        Expanded(
          child: Text(
            gruppi.nome,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 20,
          child: Text(gruppi.pg.toString()),
        ),
        SizedBox(
          width: 20,
          child: Text(gruppi.v.toString()),
        ),
        SizedBox(
          width: 20,
          child: Text(gruppi.p.toString()),
        ),
        SizedBox(
          width: 20,
          child: Text(gruppi.s.toString()),
        ),
        SizedBox(
          width: 20,
          child: Text(gruppi.pt.toString()),
        ),
      ],
    );
  }
}
