import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../blocs/blocs.dart';
import '../../utils/ui_helpers.dart';

class WidgetParametriGiocatore extends StatefulWidget {
  final String gruppo;
  final Giocatore? giocatore;

  const WidgetParametriGiocatore({
    Key? key,
    required this.gruppo,
    this.giocatore,
  }) : super(key: key);

  @override
  State<WidgetParametriGiocatore> createState() =>
      _WidgetParametriGiocatoreState();
}

class _WidgetParametriGiocatoreState extends State<WidgetParametriGiocatore> {
  String? nome;
  File? file;
  int? ruolo;
  String? image;

  @override
  void initState() {
    if (widget.giocatore != null) {
      nome = widget.giocatore!.nome;
      ruolo = widget.giocatore!.image;
      image = widget.giocatore!.photo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  widget.giocatore != null
                      ? 'Modifica il giocatore'
                      : 'Un nuovo giocatore, eh?',
                  style: Theme.of(context).textTheme.headline5),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  initialValue: this.nome,
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
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: OutlinedButton(
                    child: Text('Scegli il ruolo'),
                    onPressed: () async {
                      final ruolo = await showConfirmationDialog(
                        context: context,
                        title: 'Che bel giocatore!',
                        message: 'Modifica il ruolo',
                        initialSelectedActionKey: this.ruolo,
                        actions: [
                          AlertDialogAction(key: 0, label: 'Portiere'),
                          AlertDialogAction(key: 1, label: 'Difensore'),
                          AlertDialogAction(key: 2, label: 'Terzino'),
                          AlertDialogAction(key: 3, label: 'Ala'),
                          AlertDialogAction(key: 4, label: 'Centravanti'),
                        ],
                      );
                      if (ruolo != null) {
                        setState(() {
                          this.ruolo = ruolo;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: OutlinedButton(
                    child: Text('Carica una foto'),
                    onPressed: () async {
                      XFile? result = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (result != null) {
                        final croppedImage = await cropImage(
                          this.context,
                          'Ritaglia l\'immagine',
                          File(result.path),
                          CropAspectRatio(ratioX: 1, ratioY: 1.5),
                        );
                        if (croppedImage != null) {
                          setState(() {
                            this.file = croppedImage;
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox.square(
                dimension: 150,
                child: this.ruolo != null
                    ? playerImages[this.ruolo!]
                    : Container(),
              ),
              SizedBox.square(
                dimension: 150,
                child: this.file != null
                    ? Image.file(File(this.file!.path))
                    : this.image != null
                        ? FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: this.image!,
                          )
                        : Container(),
              )
            ],
          )),
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
                    if (this.nome != null && this.ruolo != null) {
                      final giocatoreUpdated = widget.giocatore?.copyWith(
                            nome: this.nome,
                            gruppo: widget.gruppo,
                            image: this.ruolo,
                          ) ??
                          null;
                      if (giocatoreUpdated != null) {
                        context.read<GiocatoriBloc>().add(GiocatoriAggiorna(
                              giocatoreUpdated,
                              this.file?.path ?? null,
                            ));
                      } else {
                        context.read<GiocatoriBloc>().add(GiocatoriCrea(
                              this.nome!.trim(),
                              widget.gruppo,
                              this.ruolo!,
                              this.file?.path ?? null,
                            ));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Center(
                    child: Text(widget.giocatore != null ? 'Aggiorna' : 'Crea'),
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
