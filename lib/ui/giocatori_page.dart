import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/models/giocatore.dart';
import 'package:quaderno_flutter/utils/ui_helpers.dart';

class GiocatoriPage extends StatelessWidget {
  final String gruppo;
  GiocatoriPage(this.gruppo);

  static Route route(String gruppo) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) => GiocatoriBloc()..add(GiocatoriLoaded()),
              child: GiocatoriPage(gruppo),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text('${this.gruppo}'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<GiocatoriBloc>().add(GiocatoriLoaded()),
            icon: Icon(Icons.autorenew_rounded),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          authState.status == AuthenticationStatus.authenticated
              ? FloatingActionButton(
                  child: Center(child: Icon(Icons.person_add_alt_1_rounded)),
                  onPressed: () async {
                    final result = await showTextInputDialog(
                      context: context,
                      title: 'Che bel giocatore!',
                      message: 'Inserisci nome del nuovo giocatore',
                      textFields: [
                        DialogTextField(
                          hintText: 'nome',
                          validator: (input) =>
                              input!.isNotEmpty ? null : 'Inserire nome valido',
                        )
                      ],
                    );
                    if (result != null && result.length == 1) {
                      context
                          .read<GiocatoriBloc>()
                          .add(GiocatoriCrea(result[0], this.gruppo));
                    }
                  },
                )
              : null,
      body: BlocBuilder<GiocatoriBloc, GiocatoriState>(
        builder: (context, state) {
          if (state is GiocatoriLoading || state is GiocatoriInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GiocatoriLoadFailure) {
            return Center(
              child: Text(state.message),
            );
          } else {
            final giocatori = (state as GiocatoriLoadSuccess).giocatori;
            final filtered = giocatori
                .where((giocatore) => giocatore.gruppo == gruppo)
                .toList();
            final mappaGiocatori = Map.fromIterable(filtered,
                key: (item) => item as Giocatore,
                value: (item) => (playerImages..shuffle()).first);
            return GrigliaGiocatori(giocatori: mappaGiocatori);
          }
        },
      ),
    );
  }
}

class GrigliaGiocatori extends StatefulWidget {
  const GrigliaGiocatori({
    Key? key,
    required this.giocatori,
  }) : super(key: key);

  // final List<Giocatore> giocatori;
  final Map<Giocatore, Image> giocatori;

  @override
  State<GrigliaGiocatori> createState() => _GrigliaGiocatoriState();
}

class _GrigliaGiocatoriState extends State<GrigliaGiocatori> {
  bool deletable = false;
  @override
  Widget build(BuildContext context) {
    final giocatoriBloc = BlocProvider.of<GiocatoriBloc>(context);
    final authState = context.watch<AuthenticationBloc>().state;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 7 / 8,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0),
      itemCount: widget.giocatori.length,
      itemBuilder: (context, index) {
        final entry = widget.giocatori.entries.elementAt(index);
        return WillPopScope(
          onWillPop: () async {
            if (!deletable)
              return true;
            else {
              setState(() {
                deletable = !deletable;
              });
            }
            return false;
          },
          child: InkWell(
            onLongPress: authState.status == AuthenticationStatus.authenticated
                ? () => setState(() {
                      deletable = !deletable;
                    })
                : null,
            onTap: !deletable &&
                    authState.status == AuthenticationStatus.authenticated
                ? () async {
                    final result = await showTextInputDialog(
                      context: context,
                      title: 'Che bel giocatore!',
                      message: 'Modifica il giocatore',
                      textFields: [
                        DialogTextField(
                          hintText: 'nome',
                          keyboardType: TextInputType.visiblePassword,
                          // * Use a space after text or the above keyboard
                          // * type to avoid replication issue
                          // initialText: entry.key.nome + ' ',
                          initialText: entry.key.nome,
                          validator: (input) =>
                              input!.isNotEmpty ? null : 'Inserire nome valido',
                        )
                      ],
                    );
                    if (result != null && result.length == 1) {
                      giocatoriBloc.add(GiocatoriAggiorna(
                          entry.key.copyWith(nome: result[0])));
                    }
                  }
                : null,
            child: Card(
              margin: EdgeInsets.all(4.0),
              elevation: deletable ? 8 : 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 4.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    deletable &&
                            authState.status ==
                                AuthenticationStatus.authenticated
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () async {
                                final result = await showOkCancelAlertDialog(
                                  context: context,
                                  title: 'Attenzione',
                                  message:
                                      'Eliminare ${entry.key.nome} (${entry.key.gruppo})?',
                                );
                                if (result == OkCancelResult.ok) {
                                  giocatoriBloc
                                      .add(GiocatoriElimina(entry.key.id));
                                }
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ))
                        : Container(),
                    Positioned(
                      top: 0.0,
                      left: 20,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: entry.value,
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          entry.key.nome,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      left: 12,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text('${entry.key.gol}'),
                              ),
                              Image.asset(
                                'assets/images/golfatto.png',
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text('${entry.key.ammonizioni}'),
                              ),
                              Image.asset(
                                'assets/images/ammonito.png',
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text('${entry.key.espulsioni}'),
                              ),
                              Image.asset(
                                'assets/images/espulso.png',
                                fit: BoxFit.fill,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
