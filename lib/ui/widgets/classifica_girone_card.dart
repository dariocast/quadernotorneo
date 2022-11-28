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
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3,
      child: ListView(
        children: [
          _headerRow(context),
          _rows(context),
        ],
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
}

Widget _rows(BuildContext context) {
  return Row(
    children: [],
  );
}
