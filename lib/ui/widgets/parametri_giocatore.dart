import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/models.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../blocs/blocs.dart';
import '../../utils/ui_helpers.dart';

class WidgetParametriGiocatore extends StatefulWidget {
  final String gruppo;
  final Giocatore? giocatore;

  const WidgetParametriGiocatore({
    super.key,
    required this.gruppo,
    this.giocatore,
  });

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
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  initialValue: nome,
                  onChanged: (value) => setState(() {
                    nome = value;
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
                            file = croppedImage;
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
                child: ruolo != null ? playerImages[ruolo!] : Container(),
              ),
              SizedBox.square(
                dimension: 150,
                child: file != null
                    ? Image.file(File(file!.path))
                    : image != null
                        ? FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: image!,
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
                    if (nome != null && ruolo != null) {
                      final giocatoreUpdated = widget.giocatore?.copyWith(
                        nome: nome,
                        gruppo: widget.gruppo,
                        image: ruolo,
                      );
                      if (giocatoreUpdated != null) {
                        context.read<GiocatoriBloc>().add(GiocatoriAggiorna(
                              giocatoreUpdated,
                              file?.path,
                            ));
                      } else {
                        context.read<GiocatoriBloc>().add(GiocatoriCrea(
                              nome!.trim(),
                              widget.gruppo,
                              ruolo!,
                              file?.path,
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
