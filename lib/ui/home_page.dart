import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/ui/ui.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) => HomeBloc()..add(HomeLoaded()),
              child: HomePage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew_rounded),
            onPressed: () {
              context.read<HomeBloc>().add(HomeLoaded());
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
          )
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (_) => DettaglioBloc()
                              ..add(DettaglioLoaded(state.partite[index])),
                            child: DettaglioPage(),
                          ),
                        ),
                      ),
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
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
