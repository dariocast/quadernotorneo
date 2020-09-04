import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/src/blocs/bloc.dart';
import '../models/models.dart';

class VistaQuaderno extends StatelessWidget {
  static const routeName = '/vista_quaderno';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partite'),
      ),
      body: BlocProvider(
        create: (context) => PartitaBloc()..add(PartitaLoaded()),
        child: lista(),
      ),
    );
  }

  Widget lista() {
    return BlocBuilder<PartitaBloc, PartitaState>(builder: (context, state) {
      if (state is PartitaInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is PartitaFailure) {
        return Center(
          child: Text('Impossibile caricare le partite'),
        );
      }
      if (state is PartitaSuccess) {
        if (state.partite.isEmpty) {
          return Center(
            child: Text('Nessuna partita'),
          );
        }
        return ListView.builder(
            itemCount: state.partite.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(state.partite[index].squadra1,
                                textAlign: TextAlign.left)),
                        Expanded(
                            child: Text(
                          '${state.partite[index].golSquadra1} - ${state.partite[index].golSquadra2}',
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: Text(state.partite[index].squadra2,
                                textAlign: TextAlign.right)),
                      ],
                    ),
                  ));
            });
      }
    });
  }
}
