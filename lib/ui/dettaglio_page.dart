import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/ui/ui.dart';

class DettaglioPage extends StatelessWidget {
  static final String routeName = '/dettaglio';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DettaglioPage());
  }

  @override
  Widget build(BuildContext context) {
    final DettaglioState state = context.watch<DettaglioBloc>().state;
    if (state.loading)
      return Center(child: CircularProgressIndicator());
    else {
      return Scaffold(
        appBar: AppBar(
          title:
              Text('${state.partita!.squadra1} vs ${state.partita!.squadra2}'),
        ),
        body: PartitaWidget(state.partita!),
      );
    }
  }
}
