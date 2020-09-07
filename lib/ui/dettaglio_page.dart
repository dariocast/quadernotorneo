import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/ui/ui.dart';

class DettaglioPage extends StatelessWidget {
  static const String routeName = '/dettaglio';

  @override
  Widget build(BuildContext context) {
    final PartitaModel partita = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('${partita.squadra1} vs ${partita.squadra2}'),
      ),
      body: PartitaWidget(partita),
    );
  }
}
