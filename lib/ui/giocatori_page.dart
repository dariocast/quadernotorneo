import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/blocs.dart';
import '../models/giocatore.dart';
import '../utils/ui_helpers.dart';
import 'widgets/widgets.dart';

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
          authState.status == AuthenticationStatus.authenticated
              ? IconButton(
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: BlocProvider.of<GiocatoriBloc>(context),
                            child:
                                WidgetCreazioneGiocatore(gruppo: this.gruppo),
                          );
                        },
                      ),
                  icon: Icon(Icons.person_add_alt_1_rounded))
              : Container(),
          IconButton(
            onPressed: () =>
                context.read<GiocatoriBloc>().add(GiocatoriLoaded()),
            icon: Icon(Icons.autorenew_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<GiocatoriBloc, GiocatoriState>(
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

                return filtered.isNotEmpty
                    ? GrigliaGiocatori(
                        giocatori: filtered,
                        key: GlobalKey(),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FaIcon(FontAwesomeIcons.users, size: 30.0),
                            ),
                            Text('Questo gruppo non ha giocatori'),
                          ],
                        ),
                      );
              }
            },
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 100.0,
            child: QuadernoBannerAd(),
          )
        ],
      ),
    );
  }
}

class GrigliaGiocatori extends StatefulWidget {
  const GrigliaGiocatori({
    Key? key,
    required this.giocatori,
  }) : super(key: key);

  final List<Giocatore> giocatori;

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
        final giocatore = widget.giocatori.elementAt(index);
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
                    final nome = await showTextInputDialog(
                      context: context,
                      title: 'Che bel giocatore!',
                      message: 'Modifica il nome',
                      textFields: [
                        DialogTextField(
                          hintText: 'nome',
                          keyboardType: TextInputType.visiblePassword,
                          // * Use a space after text or the above keyboard
                          // * type to avoid replication issue
                          // initialText: entry.key.nome + ' ',
                          initialText: giocatore.nome,
                          validator: (input) =>
                              input!.isNotEmpty ? null : 'Inserire nome valido',
                        ),
                      ],
                    );
                    if (nome != null && nome.length == 1) {
                      final immagine = await showConfirmationDialog(
                        context: context,
                        title: 'Che bel giocatore!',
                        message: 'Modifica il ruolo',
                        initialSelectedActionKey: giocatore.image,
                        actions: [
                          AlertDialogAction(key: 0, label: 'Portiere'),
                          AlertDialogAction(key: 1, label: 'Difensore'),
                          AlertDialogAction(key: 2, label: 'Terzino'),
                          AlertDialogAction(key: 3, label: 'Ala'),
                          AlertDialogAction(key: 4, label: 'Centravanti'),
                        ],
                      );
                      if (immagine != null) {
                        giocatoriBloc.add(
                          GiocatoriAggiorna(
                            giocatore.copyWith(
                              nome: nome[0],
                              image: immagine,
                            ),
                          ),
                        );
                      }
                    }
                  }
                : authState.status == AuthenticationStatus.authenticated
                    ? () async {
                        final result = await showOkCancelAlertDialog(
                          context: context,
                          title: 'Attenzione',
                          message:
                              'Eliminare ${giocatore.nome} (${giocatore.gruppo})?',
                        );
                        if (result == OkCancelResult.ok) {
                          giocatoriBloc.add(GiocatoriElimina(giocatore.id));
                        }
                      }
                    : null,
            child: Card(
              elevation: deletable ? 8 : 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 3.0, right: 5.0, top: 5.0, bottom: 4.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 15.0,
                      right: 20.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: giocatore.photo == null
                            ? playerImages[giocatore.image]
                            : Image.network(giocatore.photo!),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          giocatore.nome,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      left: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text('${giocatore.gol}'),
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
                                child: Text('${giocatore.ammonizioni}'),
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
                                child: Text('${giocatore.espulsioni}'),
                              ),
                              Image.asset(
                                'assets/images/espulso.png',
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 150,
                              width: 35,
                              child: playerImages[giocatore.image]),
                        ],
                      ),
                    ),
                    deletable &&
                            authState.status ==
                                AuthenticationStatus.authenticated
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                            ),
                          )
                        : Container(),
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
