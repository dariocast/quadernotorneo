import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';
import '../blocs/tornei/tornei_bloc.dart';
import 'ui.dart';

class TorneiPage extends StatelessWidget {
  static const String routeName = '/tornei';

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => TorneiBloc()..add(TorneiLoaded()),
        child: TorneiPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

    return Scaffold(
      drawer: HomeDrawer(onlyLogin: true),
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.tournamentPageTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.autorenew_rounded),
            onPressed: () {
              context.read<TorneiBloc>().add(TorneiLoaded());
            },
          ),
        ],
      ),
      body: BlocBuilder<TorneiBloc, TorneiState>(builder: (context, state) {
        if (state is TorneiLoadSuccess) {
          if (state.tornei.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.triangleExclamation,
                        size: 30.0),
                  ),
                  Text(AppLocalizations.of(context)!.tournamentPageEmpty),
                ],
              ),
            );
          }
          return Stack(children: [
            ListView.builder(
              itemCount: state.tornei.length,
              itemBuilder: (context, index) {
                final torneo = state.tornei[index];
                return Card(
                  child: ListTile(
                    title: Text(torneo.name),
                    trailing: FaIcon(FontAwesomeIcons.folderOpen),
                    onTap: () => Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => PartiteBloc()
                                ..add(PartiteLoaded(torneo.name)),
                              child: PartitePage(torneo: torneo.name),
                            ),
                          ),
                        )
                        .whenComplete(() =>
                            context.read<TorneiBloc>().add(TorneiLoaded())),
                  ),
                );
              },
            ),
          ]);
        } else if (state is TorneiLoadFailure) {
          return Center(
            child:
                Text(AppLocalizations.of(context)!.tournamentPageLoadFailure),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
