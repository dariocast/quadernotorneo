import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';
import 'widgets/widgets.dart';

class MarcatoriPage extends StatelessWidget {
  final String? torneo;
  const MarcatoriPage(this.torneo, {super.key});

  static Route route(String? torneo) {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) =>
                  MarcatoriBloc()..add(MarcatoriLoaded(torneo)),
              child: MarcatoriPage(torneo),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scorersPageTitle),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  context.read<MarcatoriBloc>().add(MarcatoriLoaded(torneo)),
              icon: Icon(Icons.autorenew_rounded)),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<MarcatoriBloc, MarcatoriState>(builder: (context, state) {
            if (state is MarcatoriLoadFailure) {
              return Center(
                child:
                    Text(AppLocalizations.of(context)!.scorersPageLoadFailure),
              );
            } else if (state is MarcatoriLoadSuccess) {
              return state.marcatori.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.faceSadTear,
                                size: 30.0),
                          ),
                          Text(AppLocalizations.of(context)!.scorersPageEmpty),
                        ],
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      padding: EdgeInsets.all(5.0),
                      itemCount: state.marcatori.length,
                      itemBuilder: (context, index) {
                        final marcatore = state.marcatori[index];
                        final logoUrl = state.loghi[marcatore.gruppo];
                        return ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(logoUrl!),
                          ),
                          title: Text(marcatore.nome),
                          subtitle: Text(marcatore.gruppo),
                          trailing: Text(marcatore.gol.toString(),
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              )),
                        );
                      });
            }
            return Center(child: CircularProgressIndicator());
          }),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 5.0,
            child: QuadernoBannerAd(),
          )
        ],
      ),
    );
  }
}
