import 'package:flutter/material.dart';
import '../models/partita_model.dart';
import '../blocs/partite_bloc.dart';

class VistaQuaderno extends StatelessWidget {
  static const routeName = '/vista_quaderno';
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllPartite();
    return Scaffold(
      appBar: AppBar(
        title: Text('Partite'),
      ),
      body: StreamBuilder(
        stream: bloc.partite,
        builder: (context, AsyncSnapshot<List<PartitaModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<List<PartitaModel>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(snapshot.data[index].squadra1,
                            textAlign: TextAlign.left)),
                    Expanded(
                        child: Text(
                      '${snapshot.data[index].golSquadra1} - ${snapshot.data[index].golSquadra2}',
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(snapshot.data[index].squadra2,
                            textAlign: TextAlign.right)),
                  ],
                ),
              ));
        });
  }
}
