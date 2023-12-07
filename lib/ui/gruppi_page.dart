import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';
import '../utils/ui_helpers.dart';
import 'ui.dart';
import 'widgets/widgets.dart';

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
          title: Text(AppLocalizations.of(context)!.teamPageTitle),
          centerTitle: true,
          actions: [
            authState.status == AuthenticationStatus.authenticated &&
                    authState.user.isAdmin
                ? IconButton(
                    onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (_) {
                            final MediaQueryData mediaQueryData =
                                MediaQuery.of(context);
                            return BlocProvider.value(
                              value: BlocProvider.of<GruppiBloc>(context),
                              child: Padding(
                                padding: mediaQueryData.viewInsets,
                                child: WidgetCreazioneGruppo(),
                              ),
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
  File? file;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(AppLocalizations.of(context)!.teamCreateTitle,
                style: Theme.of(context).textTheme.headlineSmall),
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
                  labelText: AppLocalizations.of(context)!.teamCreateNameLabel,
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
                  labelText: AppLocalizations.of(context)!.teamCreateGroupLabel,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    child: this.file == null
                        ? Text(
                            AppLocalizations.of(context)!.teamCreateUploadLogo)
                        : Text(
                            AppLocalizations.of(context)!.teamCreateEditLogo),
                    onPressed: () async {
                      XFile? result = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (result != null) {
                        final croppedImage = await cropImage(
                          this.context,
                          AppLocalizations.of(context)!
                              .teamCreateCropUploadedImage,
                          File(result.path),
                          CropAspectRatio(ratioX: 1, ratioY: 1),
                        );
                        if (croppedImage != null) {
                          setState(() {
                            this.file = croppedImage;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox.square(
                    dimension: 150,
                    child: this.file != null
                        ? Image.file(File(this.file!.path))
                        : Container(),
                  )
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
                  child: Text(AppLocalizations.of(context)!.cancelButtonLabel),
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
                          this.file!.path,
                        ));
                    Navigator.of(context).pop();
                  }
                },
                child: Center(
                  child: Text(AppLocalizations.of(context)!.teamCreateButton),
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
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    final gruppiBloc = BlocProvider.of<GruppiBloc>(context);
    final authState = context.watch<AuthenticationBloc>().state;

    return Stack(
      children: [
        BlocBuilder<GruppiBloc, GruppiState>(
          builder: (context, state) {
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
                            child: Text(AppLocalizations.of(context)!.noTeams),
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
                                if (!editable)
                                  return true;
                                else {
                                  setState(() {
                                    editable = !editable;
                                  });
                                }
                                return false;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: InkWell(
                                  onLongPress: authState.status ==
                                              AuthenticationStatus
                                                  .authenticated &&
                                          authState.user.isAdmin
                                      ? () => setState(() {
                                            editable = !editable;
                                          })
                                      : null,
                                  onTap: !editable &&
                                          authState.status ==
                                              AuthenticationStatus
                                                  .authenticated &&
                                          authState.user.isAdmin
                                      ? () {
                                          Navigator.of(context).push(
                                              GiocatoriPage.route(
                                                  gruppi[index].nome));
                                        }
                                      : authState.status ==
                                                  AuthenticationStatus
                                                      .authenticated &&
                                              authState.user.isAdmin
                                          ? () async {
                                              final result =
                                                  await showOkCancelAlertDialog(
                                                context: context,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .deleteWarningTitle,
                                                message:
                                                    '${AppLocalizations.of(context)!.teamDeleteLabel} ${gruppi[index].nome} ${AppLocalizations.of(context)!.teamDeleteWithPlayersLabel}',
                                              );
                                              if (result == OkCancelResult.ok) {
                                                gruppiBloc.add(GruppiElimina(
                                                    gruppi[index].id));
                                              }
                                            }
                                          : null,
                                  child: Card(
                                    elevation: editable ? 8 : 1,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: SizedBox(
                                              height: 130,
                                              child: FadeInImage.memoryNetwork(
                                                  fadeInDuration: Duration(
                                                      milliseconds: 300),
                                                  placeholder:
                                                      kTransparentImage,
                                                  image: gruppi[index].logo),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Text(
                                              '${gruppi[index].nome}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                shadows: [
                                                  Shadow(
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 10.0,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        editable &&
                                                authState.status ==
                                                    AuthenticationStatus
                                                        .authenticated &&
                                                authState.user.isAdmin
                                            ? Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Icon(
                                                  Icons.delete_forever_rounded,
                                                  color: Colors.red,
                                                ))
                                            : Container(),
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
                child: Text(AppLocalizations.of(context)!.teamLoadFailure),
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
