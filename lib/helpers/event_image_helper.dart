import 'package:flutter/material.dart';
import '../models/evento.dart';
import 'package:transparent_image/transparent_image.dart';

Image eventImage(TipoEvento event) {
  switch (event) {
    case TipoEvento.GOL:
      return const Image(image: AssetImage('assets/images/golfatto.png'));
    case TipoEvento.AUTOGOL:
      return const Image(image: AssetImage('assets/images/autogol.png'));
    case TipoEvento.AMMONIZIONE:
      return const Image(image: AssetImage('assets/images/ammonito.png'));
    case TipoEvento.ESPULSIONE:
      return const Image(image: AssetImage('assets/images/espulso.png'));
    case TipoEvento.FALLO:
      return Image.memory(kTransparentImage);
  }
}
