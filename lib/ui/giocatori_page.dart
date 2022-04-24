import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/blocs.dart';
import '../models/giocatore.dart';
import 'widgets/widgets.dart';
import '../utils/ui_helpers.dart';

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
              // ? IconButton(
              //     onPressed: () async {
              //       final result = await showTextInputDialog(
              //         context: context,
              //         title: 'Che bel giocatore!',
              //         message: 'Inserisci nome del nuovo giocatore',
              //         textFields: [
              //           DialogTextField(
              //             hintText: 'nome',
              //             validator: (input) =>
              //                 input!.isNotEmpty ? null : 'Inserire nome valido',
              //           ),
              //         ],
              //       );
              //       if (result != null && result.length == 1) {
              //         final immagine = await showConfirmationDialog(
              //           context: context,
              //           title: 'Che bel giocatore!',
              //           message: 'Scegli il ruolo',
              //           actions: [
              //             AlertDialogAction(key: 0, label: 'Portiere'),
              //             AlertDialogAction(key: 1, label: 'Difensore'),
              //             AlertDialogAction(key: 2, label: 'Terzino'),
              //             AlertDialogAction(key: 3, label: 'Ala'),
              //             AlertDialogAction(key: 4, label: 'Centravanti'),
              //           ],
              //         );
              //         if (immagine != null) {
              //           FilePickerResult? photo =
              //               await FilePicker.platform.pickFiles(
              //             type: FileType.image,
              //             allowMultiple: false,
              //           );
              //           if (photo != null) {
              //             final photoFile = photo.files.first;
              //             context.read<GiocatoriBloc>().add(
              //                   GiocatoriCrea(
              //                     result[0],
              //                     this.gruppo,
              //                     immagine,
              //                     photoFile.path!,
              //                   ),
              //                 );
              //           }
              //         }
              //       }
              //     },
              //     icon: Icon(Icons.person_add_alt_1_rounded))
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
                    ? GrigliaGiocatori(giocatori: filtered)
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
                padding:
                    const EdgeInsets.only(left: 3.0, top: 5.0, bottom: 4.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    deletable &&
                            authState.status ==
                                AuthenticationStatus.authenticated
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                            ))
                        : Container(),
                    Positioned(
                      top: 10.0,
                      right: 0.0,
                      child: SizedBox(
                        width: 150,
                        height: 150,
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
                      left: 12,
                      child: Column(
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

class WidgetCreazioneGiocatore extends StatefulWidget {
  final String gruppo;

  const WidgetCreazioneGiocatore({
    Key? key,
    required this.gruppo,
  }) : super(key: key);

  @override
  State<WidgetCreazioneGiocatore> createState() =>
      _WidgetCreazioneGiocatoreState();
}

class _WidgetCreazioneGiocatoreState extends State<WidgetCreazioneGiocatore> {
  String? nome;
  XFile? file;
  int source = 0;
  int ruolo = 3;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Un nuovo giocatore, eh?',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  onChanged: (value) => setState(() {
                    this.nome = value;
                  }),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ),
                ),
              ),
            ),
          ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(3.0),
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.8,
          //       child: TextButton(
          //         child: Text('Scegli il ruolo'),
          //         onPressed: () async {
          //           final ruolo = await showConfirmationDialog(
          //             context: context,
          //             title: 'Che bel giocatore!',
          //             message: 'Modifica il ruolo',
          //             initialSelectedActionKey: this.ruolo,
          //             actions: [
          //               AlertDialogAction(key: 0, label: 'Portiere'),
          //               AlertDialogAction(key: 1, label: 'Difensore'),
          //               AlertDialogAction(key: 2, label: 'Terzino'),
          //               AlertDialogAction(key: 3, label: 'Ala'),
          //               AlertDialogAction(key: 4, label: 'Centravanti'),
          //             ],
          //           );
          //           if (ruolo != null) {
          //             setState(() {
          //               this.ruolo = ruolo;
          //             });
          //           }
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Carica una foto'),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.photo,
                            color: this.file != null && this.source == 1
                                ? Colors.green
                                : Colors.red,
                          ),
                          onPressed: () async {
                            XFile? result = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (result != null) {
                              setState(() {
                                this.file = result;
                                this.source = 1;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: this.file != null && this.source == 2
                                ? Colors.green
                                : Colors.red,
                          ),
                          onPressed: () async {
                            XFile? result = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (result != null) {
                              setState(() {
                                this.file = result;
                                this.source = 2;
                              });
                            }
                          },
                        ),
                        this.file != null
                            ? SizedBox(
                                height: 50.0,
                                child: Image.file(File(this.file!.path)),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Center(
                    child: Text('Annulla'),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (this.nome != null &&
                        this.ruolo != null &&
                        this.file != null) {
                      context.read<GiocatoriBloc>().add(GiocatoriCrea(
                            this.nome!.trim(),
                            widget.gruppo,
                            this.ruolo,
                            this.file!.path,
                          ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Center(
                    child: Text('Crea'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
