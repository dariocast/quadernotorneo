import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quaderno_flutter/ui/widgets/classifica_girone_card.dart';

import '../blocs/blocs.dart';
import 'widgets/widgets.dart';

class ClassificaPage extends StatefulWidget {
  const ClassificaPage({super.key});

  static Route route(String? torneo) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) =>
                  ClassificaBloc(torneo)..add(ClassificaLoaded()),
              child: ClassificaPage(),
            ));
  }

  @override
  State<ClassificaPage> createState() => _ClassificaPageState();
}

class _ClassificaPageState extends State<ClassificaPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ClassificaBloc>().state;
    List<String> gironi = [];

    // Populate `gironi` list only if state is ClassificaLoadSuccess
    if (state is ClassificaLoadSuccess) {
      gironi = state.gruppi.map((gruppo) => gruppo.girone).toSet().toList();
      gironi.sort((a, b) => a.compareTo(b));
      // Ensure `_currentIndex` stays within bounds if `gironi` is populated
      _currentIndex =
          _currentIndex.clamp(0, (gironi.isNotEmpty ? gironi.length - 1 : 0));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.leaderboardTitle),
        centerTitle: true,
      ),
      bottomNavigationBar: (gironi.length >= 2)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: gironi
                  .map((e) => BottomNavigationBarItem(
                      icon: Icon(Icons.flag_rounded),
                      label:
                          "${AppLocalizations.of(context)!.groupLabel} ${e.toUpperCase()}"))
                  .toList(),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index.clamp(0, gironi.length - 1);
                });
              },
            )
          : null,
      body: BlocBuilder<ClassificaBloc, ClassificaState>(
          builder: (context, state) {
        if (state is ClassificaLoadFailure) {
          return Center(
            child: Text(AppLocalizations.of(context)!.leaderboardLoadFailure),
          );
        } else if (state is ClassificaLoadSuccess && gironi.isNotEmpty) {
          final gruppiPerGirone = state.gruppi
              .where((element) => element.girone == gironi[_currentIndex])
              .toList();
          gruppiPerGirone.sort((a, b) => b.ordinaClassifica(a));
          // return ClassificaWidget(gruppiPerGirone);
          return state.gruppi.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(FontAwesomeIcons.medal, size: 30.0),
                      ),
                      Text(AppLocalizations.of(context)!.leaderboardsPageEmpty),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      top: 0.0,
                      bottom: 50.0, // Lascia spazio per l'annuncio
                      child: ClassificaGironeWidget(
                        gironi[_currentIndex],
                        gruppiPerGirone,
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: 5.0,
                      child: QuadernoBannerAd(),
                    ),
                  ],
                );
        } else if (state is ClassificaLoadSuccess && gironi.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.leaderboard_rounded, size: 30.0),
                ),
                Text(AppLocalizations.of(context)!.leaderboardsEmpty),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
