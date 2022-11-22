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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            final authState = context.watch<AuthenticationBloc>().state;
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
                                AppLocalizations.of(context)!
                                    .drawerWelcomeLabel,
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
                              title: Text(AppLocalizations.of(context)!
                                  .drawerScorersLabel),
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
                              title: Text(AppLocalizations.of(context)!
                                  .drawerLeaderboardsLabel),
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
                              title: Text(AppLocalizations.of(context)!
                                  .drawerTeamsLabel),
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
                              title: Text(AppLocalizations.of(context)!
                                  .drawerFantasyGameLabel),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<void>(
                                  builder: (_) => WebviewScaffold(
                                    url:
                                        "https://dariocast.altervista.org/fantatorneo",
                                    appBar: AppBar(
                                      title: Text(AppLocalizations.of(context)!
                                          .drawerFantasyGameLabel),
                                    ),
                                  ),
                                ));
                              },
                            )
                          : Container(),
                      authState.status == AuthenticationStatus.authenticated &&
                              !onlyLogin &&
                              authState.user.isAdmin
                          ? Divider()
                          : Container(),
                      authState.status == AuthenticationStatus.authenticated &&
                              !onlyLogin &&
                              authState.user.isAdmin
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .drawerManagementLabel,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            )
                          : Container(),
                      authState.status == AuthenticationStatus.authenticated &&
                              !onlyLogin &&
                              authState.user.isAdmin
                          ? ListTile(
                              trailing: Icon(
                                Icons.update,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text(AppLocalizations.of(context)!
                                  .drawerManagementUpdateScorers),
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: AppLocalizations.of(context)!
                                        .drawerManagementUpdateScorersDialogTitle,
                                    message: AppLocalizations.of(context)!
                                        .drawerManagementUpdateScorersDialogMessage);
                                if (result == OkCancelResult.ok) {
                                  context
                                      .read<DrawerCubit>()
                                      .aggiornaMarcatori();
                                }
                              },
                            )
                          : Container(),
                      authState.status == AuthenticationStatus.authenticated &&
                              !onlyLogin &&
                              authState.user.isAdmin
                          ? ListTile(
                              trailing: Icon(
                                Icons.calculate,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text(AppLocalizations.of(context)!
                                  .drawerManagementUpdateLeaderboard),
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: AppLocalizations.of(context)!
                                        .drawerManagementUpdateLeaderboardDialogTitle,
                                    message: AppLocalizations.of(context)!
                                        .drawerManagementUpdateLeaderboardDialogMessage);
                                if (result == OkCancelResult.ok) {
                                  context
                                      .read<DrawerCubit>()
                                      .aggiornaClassifica();
                                }
                              },
                            )
                          : Container(),
                      authState.status == AuthenticationStatus.authenticated &&
                              !onlyLogin &&
                              authState.user.isAdmin
                          ? ListTile(
                              trailing: Icon(
                                Icons.restart_alt,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text(AppLocalizations.of(context)!
                                  .drawerManagementResetLeaderboard),
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: AppLocalizations.of(context)!
                                        .drawerManagementResetLeaderboardDialogTitle,
                                    message: AppLocalizations.of(context)!
                                        .drawerManagementResetLeaderboardDialogMessage);
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
                        title:
                            Text(AppLocalizations.of(context)!.drawerInfoLabel),
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
                      if (authState.status ==
                          AuthenticationStatus.authenticated) {
                        final result = await showOkCancelAlertDialog(
                          context: context,
                          title: AppLocalizations.of(context)!
                              .drawerLogoutDialogTitle,
                          message: AppLocalizations.of(context)!
                              .drawerLogoutDialogMessage,
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
                        authState.status == AuthenticationStatus.authenticated
                            ? AppLocalizations.of(context)!
                                .drawerLogoutButtonLabel
                            : AppLocalizations.of(context)!
                                .drawerLoginButtonLabel,
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
