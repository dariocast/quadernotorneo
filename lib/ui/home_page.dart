import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/ui/ui.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context
                  .bloc<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => PartitaBloc()..add(HomeLoaded()),
        child: lista(),
      ),
    );
  }

  Widget lista() {
    return BlocBuilder<PartitaBloc, HomeState>(builder: (context, state) {
      if (state is HomeInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is HomeFailure) {
        return Center(
          child: Text('Impossibile caricare le partite'),
        );
      }
      if (state is HomeSuccess) {
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
                    onTap: () => Navigator.of(context).pushNamed(
                        DettaglioPage.routeName,
                        arguments: state.partite[index]),
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
