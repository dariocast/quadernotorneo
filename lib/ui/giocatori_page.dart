import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/models/giocatore.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.gruppo}'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                context.read<GiocatoriBloc>().add(GiocatoriLoaded()),
            icon: Icon(Icons.autorenew_rounded),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Center(child: Icon(Icons.person_add_alt_1_rounded)),
        onPressed: () async {
          final result = await showTextInputDialog(
            context: context,
            title: 'Che bel giocatore!',
            message: 'Inserisci nome del nuovo giocatore',
            textFields: [
              DialogTextField(
                hintText: 'nome',
                validator: (input) =>
                    input!.isNotEmpty ? null : 'Inserire nome valido',
              )
            ],
          );
          if (result != null && result.length == 1) {
            context
                .read<GiocatoriBloc>()
                .add(GiocatoriCrea(result[0], this.gruppo));
          }
        },
      ),
      body: BlocBuilder<GiocatoriBloc, GiocatoriState>(
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
            return _listaGiocatori(filtered);
          }
        },
      ),
    );
  }

  ListView _listaGiocatori(List<Giocatore> giocatori) {
    return ListView.builder(
      itemCount: giocatori.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(giocatori[index].nome),
          subtitle: Text(giocatori[index].gruppo),
          trailing: IconButton(
            onPressed: () async {
              final result = await showOkCancelAlertDialog(
                context: context,
                title: 'Attenzione',
                message:
                    'Eliminare ${giocatori[index].nome} (${giocatori[index].gruppo})?',
              );
              if (result == OkCancelResult.ok) {
                context
                    .read<GiocatoriBloc>()
                    .add(GiocatoriElimina(giocatori[index].id!));
              }
            },
            icon: Icon(Icons.delete_rounded, color: Colors.red),
          ),
          onTap: () {},
        );
      },
    );
  }
}
