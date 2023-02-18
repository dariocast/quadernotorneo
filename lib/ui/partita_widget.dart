import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/event_image_helper.dart';
import '../blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/models.dart';
import 'style_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PartitaWidget extends StatelessWidget {
  PartitaWidget();

  @override
  Widget build(BuildContext context) {
    final partita = context.select((DettaglioBloc bloc) => bloc.state.partita!);
    final eventi = context.select((DettaglioBloc bloc) => bloc.state.eventi!);
    final authStatus =
        context.select((AuthenticationBloc bloc) => bloc.state.status);
    final giocatoriSquadraUno =
        context.select((DettaglioBloc bloc) => bloc.state.giocatoriSquadraUno!);
    final giocatoriSquadraDue =
        context.select((DettaglioBloc bloc) => bloc.state.giocatoriSquadraDue!);
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/blocnotes.png'),
              fit: BoxFit.fill)),
      child: Column(
        children: [
          authStatus == AuthenticationStatus.authenticated
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetGolDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetGolDialogMessage,
                                  actions: giocatoriSquadraUno
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioAggiungiGol(GiocatoreBase(
                                          choice, partita.squadraUno)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetGolButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetAutogolDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetAutogolDialogMessage,
                                  actions: giocatoriSquadraUno
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioAggiungiAutogol(GiocatoreBase(
                                          choice, partita.squadraUno)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetAutogolButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetYellowCardDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetYellowCardDialogMessage,
                                  actions: giocatoriSquadraUno
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioAmmonisci(GiocatoreBase(
                                          choice, partita.squadraUno)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetYellowCardButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetRedCardDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetRedCardDialogMessage,
                                  actions: giocatoriSquadraUno
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioEspelli(GiocatoreBase(
                                          choice, partita.squadraUno)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetRedCardButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(AppLocalizations.of(context)!
                                .matchWidgetFoulsLabel),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 10,
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<DettaglioBloc>()
                                        .add(DettaglioAggiungiFallo(
                                            partita.squadraUno)),
                                    child: FaIcon(FontAwesomeIcons.plus),
                                    style: elevatedButtonStyle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 10,
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<DettaglioBloc>()
                                        .add(DettaglioRimuoviFallo(
                                            partita.squadraUno)),
                                    child: FaIcon(FontAwesomeIcons.minus),
                                    style: elevatedButtonStyle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  partita.falliSquadraUno.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Text(
                                '${partita.golSquadraUno}:${partita.golSquadraDue}',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetGolDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetGolDialogMessage,
                                  actions: giocatoriSquadraDue
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioAggiungiGol(GiocatoreBase(
                                          choice, partita.squadraDue)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetGolButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetAutogolDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetAutogolDialogMessage,
                                  actions: giocatoriSquadraDue
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioAggiungiAutogol(GiocatoreBase(
                                          choice, partita.squadraDue)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetAutogolButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetYellowCardDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetYellowCardDialogMessage,
                                  actions: giocatoriSquadraDue
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioAmmonisci(GiocatoreBase(
                                          choice, partita.squadraDue)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetYellowCardButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                final choice = await showConfirmationDialog(
                                  context: context,
                                  title: AppLocalizations.of(context)!
                                      .matchWidgetRedCardDialogTitle,
                                  message: AppLocalizations.of(context)!
                                      .matchWidgetRedCardDialogMessage,
                                  actions: giocatoriSquadraDue
                                      .map((e) =>
                                          AlertDialogAction(key: e, label: e))
                                      .toList(),
                                );
                                if (choice != null) {
                                  context.read<DettaglioBloc>().add(
                                      DettaglioEspelli(GiocatoreBase(
                                          choice, partita.squadraDue)));
                                }
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .matchWidgetRedCardButtonLabel),
                              style: elevatedButtonStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(AppLocalizations.of(context)!
                                .matchWidgetFoulsLabel),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 10,
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<DettaglioBloc>()
                                        .add(DettaglioAggiungiFallo(
                                            partita.squadraDue)),
                                    child: FaIcon(FontAwesomeIcons.plus),
                                    style: elevatedButtonStyle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 10,
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<DettaglioBloc>()
                                        .add(DettaglioRimuoviFallo(
                                            partita.squadraDue)),
                                    child: FaIcon(FontAwesomeIcons.minus),
                                    style: elevatedButtonStyle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  partita.falliSquadraDue.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Expanded(
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 60.0,
                          left: 50.0,
                        ),
                        child: Text(
                            '${partita.golSquadraUno}:${partita.golSquadraDue}',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                bottom: 25.0,
                right: 20.0,
              ),
              child: ListView.builder(
                itemCount: eventi.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Row(
                    mainAxisAlignment:
                        eventi[index].squadra == partita.squadraUno
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      eventi[index].squadra == partita.squadraUno
                          ? eventImage(eventi[index].tipo)
                          : Container(),
                      Text(
                        '${eventi[index].nome.trim()} ',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      eventi[index].squadra == partita.squadraUno
                          ? Container()
                          : eventImage(eventi[index].tipo),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
