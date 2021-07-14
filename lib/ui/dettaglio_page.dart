import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import 'ui.dart';

class DettaglioPage extends StatelessWidget {
  static final String routeName = '/dettaglio';
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
              title: 'Sei sicuro?',
              message: 'Tutte le modifiche non salvate andranno perse');
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
              ? Text('Dettaglio incontro')
              : Text(
                  '${state.partita!.squadraUno} vs ${state.partita!.squadraDue}'),
          actions: authState.status == AuthenticationStatus.authenticated
              ? [
                  IconButton(
                      onPressed: () async {
                        if (state.isEdit) {
                          final result = await showOkCancelAlertDialog(
                              context: context, title: 'Salvare la partita?');
                          if (result == OkCancelResult.ok && !state.loading)
                            context
                                .read<DettaglioBloc>()
                                .add(DettaglioSalvaPartita());
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text('Nessuna modifica da salvare')));
                        }
                      },
                      icon: Icon(Icons.save_outlined)),
                  IconButton(
                      onPressed: () async {
                        final result = await showOkCancelAlertDialog(
                          context: context,
                          title: 'Attenzione!',
                          message: 'Sei sicuro di voler rimuovere la partita?',
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
            : PartitaWidget(),
        floatingActionButton:
            authState.status == AuthenticationStatus.authenticated
                ? FloatingActionButton(
                    onPressed: () =>
                        context.read<DettaglioBloc>().add(DettaglioUndo()),
                    child: Icon(Icons.undo_rounded))
                : null,
      ),
    );
  }
}
