import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../ui.dart';

class PartitaCard extends StatelessWidget {
  const PartitaCard({
    super.key,
    required this.partita,
    required this.logoUno,
    required this.logoDue,
  });

  final Partita partita;
  final String logoUno;
  final String logoDue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => DettaglioBloc()..add(DettaglioLoaded(partita)),
                child: DettaglioPage(),
              ),
            ),
          )
          .whenComplete(() =>
              context.read<PartiteBloc>().add(PartiteLoaded(partita.torneo))),
      child: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GruppoDetailsColumn(
                partita: partita,
                squadra: partita.squadraUno,
                logo: logoUno,
                alignment: Alignment.centerLeft),
            GruppoDetailsColumn(
                partita: partita,
                squadra: partita.squadraDue,
                logo: logoDue,
                alignment: Alignment.centerRight),
            Align(
              alignment: Alignment.center,
              child: Builder(builder: (context) {
                // initializeDateFormatting('it_IT');
                final String dataAsString = DateFormat.yMMMMd(
                        Localizations.localeOf(context).toLanguageTag())
                    .format(partita.data);
                final String orarioAsString =
                    DateFormat.Hm().format(partita.data);
                final timeDiff =
                    DateTime.now().difference(partita.data).inMinutes;
                final isLive = timeDiff <= 50 && timeDiff >= 0;
                final terminata = timeDiff > 50;
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: [
                      partita.descrizione.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                              child: Text(
                                partita.descrizione,
                                maxLines: 2,
                              ),
                            )
                          : Container(),
                      Text(
                        '${partita.golSquadraUno} - ${partita.golSquadraDue}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          dataAsString,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          orarioAsString,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      isLive
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlinkText(
                                AppLocalizations.of(context)!.liveLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                beginColor: Colors.red,
                                endColor: Colors.white,
                              ),
                            )
                          : Container(),
                      terminata
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.fullTime,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class GruppoDetailsColumn extends StatelessWidget {
  const GruppoDetailsColumn({
    super.key,
    required this.partita,
    required this.logo,
    required this.alignment,
    required this.squadra,
  });

  final Partita partita;
  final String logo;
  final String squadra;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                squadra,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: FadeInImage.memoryNetwork(
                  fadeInDuration: Duration(milliseconds: 300),
                  placeholder: kTransparentImage,
                  image: logo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
