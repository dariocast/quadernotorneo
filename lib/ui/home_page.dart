import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/ui/crea_page.dart';
import 'package:quaderno_flutter/ui/ui.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => HomeBloc()..add(HomeLoaded()),
        child: HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    return Scaffold(
      drawer: Drawer(
        child: _buildDrawer(context),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quaderno Torneo'),
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew_rounded),
            onPressed: () {
              context.read<HomeBloc>().add(HomeLoaded());
            },
          ),
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
                final logoUno = state.infoGruppi
                    .firstWhere((gruppo) =>
                        gruppo.nome == state.partite[index].squadraUno)
                    .logo;
                final logoDue = state.infoGruppi
                    .firstWhere((gruppo) =>
                        gruppo.nome == state.partite[index].squadraDue)
                    .logo;
                return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => DettaglioBloc()
                                    ..add(
                                        DettaglioLoaded(state.partite[index])),
                                  child: DettaglioPage(),
                                ),
                              ),
                            )
                            .whenComplete(() =>
                                context.read<HomeBloc>().add(HomeLoaded())),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(state.partite[index].squadraUno,
                                      textAlign: TextAlign.left),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    logoUno,
                                  ),
                                ),
                              ],
                            )),
                            Expanded(
                              child: Text(
                                '${state.partite[index].golSquadraUno} - ${state.partite[index].golSquadraDue}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(state.partite[index].squadraDue,
                                      textAlign: TextAlign.right),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    logoDue,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ));
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
      floatingActionButton:
          authState.status == AuthenticationStatus.authenticated
              ? FloatingActionButton(
                  onPressed: () => Navigator.of(context)
                      .push(CreaPage.route())
                      .whenComplete(
                          () => context.read<HomeBloc>().add(HomeLoaded())),
                  child: Center(
                    child: Icon(Icons.add),
                  ),
                )
              : null,
    );
  }

  _buildDrawer(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Benvenuto!',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              authState.status == AuthenticationStatus.authenticated
                  ? ListTile(
                      trailing: Icon(Icons.sports_soccer_rounded),
                      title: Text('Aggiorna marcatori'),
                      onTap: () => showOkAlertDialog(
                          context: context,
                          title: 'Coming soon',
                          message:
                              'Questa funzione sarà disponibile con i prossimi aggiornamenti'),
                    )
                  : ListTile(),
              authState.status == AuthenticationStatus.authenticated
                  ? ListTile(
                      trailing: Icon(Icons.calculate),
                      title: Text('Calcola classifica'),
                      onTap: () => showOkAlertDialog(
                          context: context,
                          title: 'Coming soon',
                          message:
                              'Questa funzione sarà disponibile con i prossimi aggiornamenti'),
                    )
                  : ListTile(),
              authState.status == AuthenticationStatus.authenticated
                  ? ListTile(
                      trailing: Icon(Icons.restart_alt),
                      title: Text('Reset classifica'),
                      onTap: () => showOkAlertDialog(
                          context: context,
                          title: 'Coming soon',
                          message:
                              'Questa funzione sarà disponibile con i prossimi aggiornamenti'),
                    )
                  : ListTile(),
            ],
          ),
        ),
        Spacer(),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: InkWell(
            onTap: () async {
              if (authState.status == AuthenticationStatus.authenticated) {
                final result = await showOkCancelAlertDialog(
                  context: context,
                  title: 'Logout',
                  message: 'Sicuro di volerti disconnettere?',
                );
                if (result == OkCancelResult.ok) {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested());
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context)
                    .push(LoginPage.route())
                    .then((value) => Navigator.of(context).pop());
              }
            },
            child: Center(
              child: Text(
                authState.status == AuthenticationStatus.authenticated
                    ? 'Logout'
                    : 'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
