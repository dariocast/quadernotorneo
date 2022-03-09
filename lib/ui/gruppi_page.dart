import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';

import '../blocs/blocs.dart';
import 'ui.dart';
import 'widgets/widgets.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GruppiPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) => GruppiBloc()..add(GruppiLoaded()),
              child: GruppiPage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    return Scaffold(
        appBar: AppBar(
          title: Text('Gruppi'),
          centerTitle: true,
          actions: [
            authState.status == AuthenticationStatus.authenticated
                ? IconButton(
                    onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: BlocProvider.of<GruppiBloc>(context),
                              child: WidgetCreazioneGruppo(),
                            );
                          },
                        ),
                    icon: Icon(Icons.add))
                : Container(),
            IconButton(
                onPressed: () => context.read<GruppiBloc>().add(GruppiLoaded()),
                icon: Icon(Icons.refresh)),
          ],
        ),
        body: VistaGruppi());
  }
}

class WidgetCreazioneGruppo extends StatefulWidget {
  const WidgetCreazioneGruppo({
    Key? key,
  }) : super(key: key);

  @override
  State<WidgetCreazioneGruppo> createState() => _WidgetCreazioneGruppoState();
}

class _WidgetCreazioneGruppoState extends State<WidgetCreazioneGruppo> {
  String? nome;
  String? girone;
  PlatformFile? file;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('Un nuovo gruppo, eh?',
                style: Theme.of(context).textTheme.headline4),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) => setState(() {
                  this.girone = value;
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Girone',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  TextButton(
                    child: this.file == null
                        ? Text('Carica un logo')
                        : Text('Cambia logo'),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: false,
                      );
                      if (result != null) {
                        setState(() {
                          this.file = result.files.first;
                        });
                        this.file = result.files.first;
                      }
                    },
                  ),
                  this.file != null ? Text(this.file!.name) : Container(),
                ],
              ),
            ),
          ),
          Row(
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
                      this.girone != null &&
                      this.file != null) {
                    context.read<GruppiBloc>().add(GruppiCrea(
                          this.nome!.trim(),
                          this.girone!.trim(),
                          this.file!.path!,
                        ));
                    Navigator.of(context).pop();
                  }
                },
                child: Center(
                  child: Text('Crea'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class VistaGruppi extends StatefulWidget {
  const VistaGruppi({
    Key? key,
  }) : super(key: key);

  @override
  State<VistaGruppi> createState() => _VistaGruppiState();
}

class _VistaGruppiState extends State<VistaGruppi> {
  bool deletable = false;

  @override
  Widget build(BuildContext context) {
    final gruppiBloc = BlocProvider.of<GruppiBloc>(context);
    final authState = context.watch<AuthenticationBloc>().state;

    return Stack(
      children: [
        BlocBuilder<GruppiBloc, GruppiState>(
          builder: (context, state) {
            // debugPrint(state.toString());
            if (state is GruppiLoadSuccess) {
              final gruppi = state.gruppi;
              gruppi.sort((a, b) => a.nome.compareTo(b.nome));
              return gruppi.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 30.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Non ci sono gruppi nel quaderno'),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 1 / 1,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0),
                          itemCount: gruppi.length,
                          itemBuilder: (context, index) {
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onLongPress: authState.status ==
                                          AuthenticationStatus.authenticated
                                      ? () => setState(() {
                                            deletable = !deletable;
                                          })
                                      : null,
                                  onTap: !deletable &&
                                          authState.status ==
                                              AuthenticationStatus.authenticated
                                      ? () {
                                          Navigator.of(context).push(
                                              GiocatoriPage.route(
                                                  gruppi[index].nome));
                                        }
                                      : authState.status ==
                                              AuthenticationStatus.authenticated
                                          ? () async {
                                              final result =
                                                  await showOkCancelAlertDialog(
                                                context: context,
                                                title: 'Attenzione',
                                                message:
                                                    'Eliminare ${gruppi[index].nome} e tutti i componenti?',
                                              );
                                              if (result == OkCancelResult.ok) {
                                                gruppiBloc.add(GruppiElimina(
                                                    gruppi[index].id));
                                              }
                                            }
                                          : null,
                                  child: Card(
                                    elevation: deletable ? 8 : 1,
                                    child: Stack(
                                      children: [
                                        deletable &&
                                                authState.status ==
                                                    AuthenticationStatus
                                                        .authenticated
                                            ? Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ))
                                            : Container(),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0),
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.network(
                                                  gruppi[index].logo),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 35.0),
                                            child: Text(
                                              '${gruppi[index].nome}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
            } else if (state is GruppiLoadFailure) {
              return Center(
                child: Text('C\'è qualche problema a caricare i gruppi'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 5.0,
          child: QuadernoBannerAd(),
        ),
      ],
    );
  }
}
