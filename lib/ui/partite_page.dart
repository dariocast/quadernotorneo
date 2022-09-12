import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quaderno_flutter/ui/ui.dart';
import 'widgets/banner.dart';
import '../utils/ad_helper.dart';
import '../blocs/blocs.dart';
import 'crea_page.dart';
import 'widgets/widgets.dart';

class PartitePage extends StatefulWidget {
  static const String routeName = '/partite';

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => PartiteBloc()..add(PartiteLoaded()),
        child: PartitePage(),
      ),
    );
  }

  @override
  _PartitePageState createState() => _PartitePageState();
}

class _PartitePageState extends State<PartitePage> {
  late BannerAd _ad;
  int orderBy = 0;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quaderno Torneo'),
        actions: [
          IconButton(
            onPressed: () async {
              final sortBy = await showConfirmationDialog(
                  initialSelectedActionKey: orderBy,
                  context: context,
                  title: 'Ordina per',
                  actions: [
                    AlertDialogAction(
                      key: 0,
                      label: 'Data partita decrescente',
                    ),
                    AlertDialogAction(
                      label: 'Data partita crescente',
                      key: 1,
                    ),
                    AlertDialogAction(
                      label: 'Data creazione decrescente',
                      key: 2,
                    ),
                    AlertDialogAction(
                      label: 'Data creazione crescente',
                      key: 3,
                    ),
                  ]);
              if (sortBy != null) {
                setState(() {
                  orderBy = sortBy;
                });
                switch (sortBy) {
                  case 0:
                    context
                        .read<PartiteBloc>()
                        .add(PartiteOrderBy(OrderBy.DATA_DESC));
                    break;
                  case 1:
                    context
                        .read<PartiteBloc>()
                        .add(PartiteOrderBy(OrderBy.DATA_ASC));
                    break;
                  case 2:
                    context
                        .read<PartiteBloc>()
                        .add(PartiteOrderBy(OrderBy.ID_DESC));
                    break;
                  case 3:
                    context
                        .read<PartiteBloc>()
                        .add(PartiteOrderBy(OrderBy.ID_ASC));
                    break;
                  default:
                    context
                        .read<PartiteBloc>()
                        .add(PartiteOrderBy(OrderBy.DATA_DESC));
                }
              }
            },
            icon: Icon(Icons.sort),
          ),
          IconButton(
            icon: Icon(Icons.autorenew_rounded),
            onPressed: () {
              context.read<PartiteBloc>().add(PartiteLoaded());
            },
          ),
        ],
      ),
      body: BlocBuilder<PartiteBloc, PartiteState>(builder: (context, state) {
        if (state is PartiteFailure) {
          return Center(
            child: Text('Impossibile caricare le partite'),
          );
        }
        if (state is PartiteSuccess) {
          if (state.partite.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.exclamationTriangle,
                        size: 30.0),
                  ),
                  Text('Nessuna partita'),
                ],
              ),
            );
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: ListView.builder(
                    itemCount: state.partite.length,
                    itemBuilder: (BuildContext context, int index) {
                      final partita = state.partite[index];
                      final logoUno = state.infoGruppi
                          .firstWhere(
                              (gruppo) => gruppo.nome == partita.squadraUno)
                          .logo;
                      final logoDue = state.infoGruppi
                          .firstWhere(
                              (gruppo) => gruppo.nome == partita.squadraDue)
                          .logo;
                      return PartitaCard(
                          partita: partita, logoUno: logoUno, logoDue: logoDue);
                    }),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 5.0,
                child: QuadernoBannerAd(),
              )
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
      floatingActionButton: authState.status ==
              AuthenticationStatus.authenticated
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context)
                  .push(CreaPage.route())
                  .whenComplete(
                      () => context.read<PartiteBloc>().add(PartiteLoaded())),
              child: Center(
                child: Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
