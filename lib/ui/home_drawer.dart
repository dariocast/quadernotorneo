import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import 'ui.dart';

class HomeDrawer extends StatelessWidget {
  final onlyLogin;

  const HomeDrawer({
    Key? key,
    this.onlyLogin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocProvider<DrawerCubit>(
        create: (context) => DrawerCubit(),
        child: Builder(
          builder: (context) {
            final authState2 = context.watch<AuthenticationBloc>().state;
            final drawerState = context.watch<DrawerCubit>().state;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 270,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              image: AssetImage('assets/images/players.png'),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Benvenuto!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.sports_soccer_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('Marcatori'),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .push(MarcatoriPage.route());
                              })
                          : Container(),
                      !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.leaderboard_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('Classifiche'),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .push(ClassificaPage.route());
                              },
                            )
                          : Container(),
                      !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.people_alt_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('Gruppi'),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(GruppiPage.route());
                              },
                            )
                          : Container(),
                      !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.extension_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('FantaTorneo'),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<void>(
                                  builder: (_) => WebviewScaffold(
                                    url:
                                        "https://dariocast.altervista.org/fantatorneo",
                                    appBar: AppBar(
                                      title: Text("FantaTorneo"),
                                    ),
                                  ),
                                ));
                              },
                            )
                          : Container(),
                      authState2.status == AuthenticationStatus.authenticated &&
                              !onlyLogin
                          ? Divider()
                          : Container(),
                      authState2.status == AuthenticationStatus.authenticated &&
                              !onlyLogin
                          ? Center(
                              child: Text(
                                'Gestione',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            )
                          : Container(),
                      authState2.status == AuthenticationStatus.authenticated &&
                              !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.update,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('Aggiorna marcatori'),
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Aggiorna Marcatori',
                                    message: 'Vuoi aggiornare i marcatori?');
                                if (result == OkCancelResult.ok) {
                                  context
                                      .read<DrawerCubit>()
                                      .aggiornaMarcatori();
                                }
                              },
                            )
                          : Container(),
                      authState2.status == AuthenticationStatus.authenticated &&
                              !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.calculate,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('Calcola classifica'),
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Aggiorna Classifica',
                                    message: 'Vuoi aggiornare la classifica?');
                                if (result == OkCancelResult.ok) {
                                  context
                                      .read<DrawerCubit>()
                                      .aggiornaClassifica();
                                }
                              },
                            )
                          : Container(),
                      authState2.status == AuthenticationStatus.authenticated &&
                              !onlyLogin
                          ? ListTile(
                              trailing: Icon(
                                Icons.restart_alt,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text('Reset classifica'),
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Reset Classifica',
                                    message:
                                        'La classifica verrà azzerata, continuare?');
                                if (result == OkCancelResult.ok) {
                                  context.read<DrawerCubit>().resetClassifica();
                                }
                              },
                            )
                          : Container(),
                      !onlyLogin ? Divider() : Container(),
                      ListTile(
                        trailing: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text('Informazioni'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(InfoPage.route());
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: drawerState.loading
                            ? LinearProgressIndicator(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (authState2.status ==
                          AuthenticationStatus.authenticated) {
                        final result = await showOkCancelAlertDialog(
                          context: context,
                          title: 'Logout',
                          message: 'Sicuro di volerti disconnettere?',
                        );
                        if (result == OkCancelResult.ok) {
                          context
                              .read<AuthenticationBloc>()
                              .add(AuthenticationLogoutRequested());
                          Navigator.of(context).pop();
                        }
                      } else {
                        Navigator.of(context)
                            .push(LoginPage.route())
                            .then((value) => Navigator.of(context).pop());
                      }
                    },
                    child: Center(
                      child: Text(
                        authState2.status == AuthenticationStatus.authenticated
                            ? 'Logout'
                            : 'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
