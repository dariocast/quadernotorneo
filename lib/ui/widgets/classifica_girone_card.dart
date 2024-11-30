import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';

class ClassificaGironeWidget extends StatelessWidget {
  const ClassificaGironeWidget(
    this.title,
    this.gruppi, {
    super.key,
  });

  final String title;
  final List<Gruppo> gruppi;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          _headerRow(context),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: gruppi.length,
              itemBuilder: (context, index) {
                return _row(context, gruppi[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${AppLocalizations.of(context)!.groupLabel} ${title.toUpperCase()}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _row(BuildContext context, Gruppo gruppo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(
                  gruppo.logo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error, size: 50.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                gruppo.nome,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
      ),
    );
  }

  Widget _rowData(BuildContext context, String text) {
    return SizedBox(
      width: 20,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
