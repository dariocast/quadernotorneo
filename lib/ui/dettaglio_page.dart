import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';
import 'ui.dart';
import 'widgets/widgets.dart';

class DettaglioPage extends StatelessWidget {
  static final String routeName = '/dettaglio';

  const DettaglioPage({super.key});
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DettaglioPage());
  }

  @override
  Widget build(BuildContext context) {
    final DettaglioState state = context.watch<DettaglioBloc>().state;
    final AuthenticationState authState =
        context.watch<AuthenticationBloc>().state;
    return WillPopScope(
      onWillPop: () async {
        if (state.isEdit) {
          final res = await showOkCancelAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.editNotSavedWarningTitle,
              message:
                  AppLocalizations.of(context)!.editNotSavedWarningMessage);
          if (res == OkCancelResult.ok) {
            return true;
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: state.loading
              ? Text(AppLocalizations.of(context)!.detailPageTitle)
              : Text(
                  '${state.partita!.squadraUno} vs ${state.partita!.squadraDue}'),
          actions: authState.status == AuthenticationStatus.authenticated &&
                  authState.user.isAdmin
              ? [
                  IconButton(
                      onPressed: () async {
                        if (state.isEdit) {
                          final result = await showOkCancelAlertDialog(
                              context: context,
                              title: AppLocalizations.of(context)!
                                  .saveDetailsAlertTitle);
                          if (result == OkCancelResult.ok && !state.loading) {
                            context
                                .read<DettaglioBloc>()
                                .add(DettaglioSalvaPartita());
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .noEditToSaveMessage)));
                        }
                      },
                      icon: Icon(Icons.save_outlined)),
                  IconButton(
                      onPressed: () async {
                        final result = await showOkCancelAlertDialog(
                          context: context,
                          title:
                              AppLocalizations.of(context)!.deleteWarningTitle,
                          message: AppLocalizations.of(context)!
                              .deleteWarningMessage,
                        );

                        if (result == OkCancelResult.ok && !state.loading) {
                          context
                              .read<DettaglioBloc>()
                              .add(DettaglioRimuoviPartita());
                          Navigator.of(context).pop(true);
                        }
                      },
                      icon: Icon(Icons.delete_rounded)),
                ]
              : null,
        ),
        body: state.loading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: PartitaWidget(),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 5.0,
                    child: QuadernoBannerAd(),
                  )
                ],
              ),
        floatingActionButton:
            authState.status == AuthenticationStatus.authenticated &&
                    authState.user.isAdmin
                ? FloatingActionButton(
                    onPressed: () =>
                        context.read<DettaglioBloc>().add(DettaglioUndo()),
                    child: Icon(Icons.undo_rounded))
                : null,
      ),
    );
  }
}
