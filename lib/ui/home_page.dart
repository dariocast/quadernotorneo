import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/banner.dart';
import '../utils/ad_helper.dart';
import '../blocs/blocs.dart';
import '../models/models.dart';
import 'crea_page.dart';
import 'ui.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      drawer: Drawer(
        child: BlocProvider<DrawerCubit>(
          create: (context) => DrawerCubit(),
          child: Builder(
            builder: (context) {
              return _buildDrawer(context);
            },
          ),
        ),
      ),
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
                        .read<HomeBloc>()
                        .add(HomeOrderBy(OrderBy.DATA_DESC));
                    break;
                  case 1:
                    context.read<HomeBloc>().add(HomeOrderBy(OrderBy.DATA_ASC));
                    break;
                  case 2:
                    context.read<HomeBloc>().add(HomeOrderBy(OrderBy.ID_DESC));
                    break;
                  case 3:
                    context.read<HomeBloc>().add(HomeOrderBy(OrderBy.ID_ASC));
                    break;
                  default:
                    context
                        .read<HomeBloc>()
                        .add(HomeOrderBy(OrderBy.DATA_DESC));
                }
              }
            },
            icon: Icon(Icons.sort),
          ),
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
    final drawerState = context.watch<DrawerCubit>().state;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 270,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    image: DecorationImage(
                      image: AssetImage('assets/images/players.png'),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Benvenuto!',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                  trailing: Icon(
                    Icons.sports_soccer_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text('Marcatori'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MarcatoriPage.route());
                  }),
              ListTile(
                trailing: Icon(
                  Icons.leaderboard_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text('Classifiche'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(ClassificaPage.route());
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.people_alt_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text('Gruppi'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(GruppiPage.route());
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.extension_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text('FantaTorneo'),
                onTap: () {
                  launch("https://dariocast.altervista.org/fantatorneo");
                },
              ),
              authState.status == AuthenticationStatus.authenticated
                  ? Divider()
                  : Container(),
              authState.status == AuthenticationStatus.authenticated
                  ? Center(
                      child: Text(
                        'Gestione',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  : Container(),
              authState.status == AuthenticationStatus.authenticated
                  ? ListTile(
                      trailing: Icon(
                        Icons.update,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text('Aggiorna marcatori'),
                      onTap: () async {
                        final result = await showOkCancelAlertDialog(
                            context: context,
                            title: 'Aggiorna Marcatori',
                            message: 'Vuoi aggiornare i marcatori?');
                        if (result == OkCancelResult.ok) {
                          context.read<DrawerCubit>().aggiornaMarcatori();
                        }
                      },
                    )
                  : Container(),
              authState.status == AuthenticationStatus.authenticated
                  ? ListTile(
                      trailing: Icon(
                        Icons.calculate,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text('Calcola classifica'),
                      onTap: () async {
                        final result = await showOkCancelAlertDialog(
                            context: context,
                            title: 'Aggiorna Classifica',
                            message: 'Vuoi aggiornare la classifica?');
                        if (result == OkCancelResult.ok) {
                          context.read<DrawerCubit>().aggiornaClassifica();
                        }
                      },
                    )
                  : Container(),
              authState.status == AuthenticationStatus.authenticated
                  ? ListTile(
                      trailing: Icon(
                        Icons.restart_alt,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text('Reset classifica'),
                      onTap: () async {
                        final result = await showOkCancelAlertDialog(
                            context: context,
                            title: 'Reset Classifica',
                            message:
                                'La classifica verrà azzerata, continuare?');
                        if (result == OkCancelResult.ok) {
                          context.read<DrawerCubit>().resetClassifica();
                        }
                      },
                    )
                  : Container(),
              Divider(),
              ListTile(
                trailing: Icon(
                  Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text('Informazioni'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(InfoPage.route());
                },
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: drawerState.loading
                    ? LinearProgressIndicator(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        // Spacer(),
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

class PartitaCard extends StatelessWidget {
  const PartitaCard({
    Key? key,
    required this.partita,
    required this.logoUno,
    required this.logoDue,
  }) : super(key: key);

  final Partita partita;
  final String logoUno;
  final String logoDue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => DettaglioBloc()..add(DettaglioLoaded(partita)),
                child: DettaglioPage(),
              ),
            ),
          )
          .whenComplete(() => context.read<HomeBloc>().add(HomeLoaded())),
      child: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GruppoDetailsColumn(
                partita: partita,
                squadra: partita.squadraUno,
                logo: logoUno,
                alignment: Alignment.centerLeft),
            GruppoDetailsColumn(
                partita: partita,
                squadra: partita.squadraDue,
                logo: logoDue,
                alignment: Alignment.centerRight),
            Align(
              alignment: Alignment.center,
              child: Builder(builder: (context) {
                initializeDateFormatting('it_IT');
                final String dataAsString =
                    DateFormat.yMMMMd('it_IT').format(partita.data);
                final String orarioAsString =
                    DateFormat.Hm().format(partita.data);
                final timeDiff =
                    DateTime.now().difference(partita.data).inMinutes;
                final isLive = timeDiff <= 50 && timeDiff >= 0;
                final terminata = timeDiff > 50;
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: [
                      partita.descrizione.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                              child: Text(
                                '${partita.descrizione}',
                                maxLines: 2,
                              ),
                            )
                          : Container(),
                      Text(
                        '${partita.golSquadraUno} - ${partita.golSquadraDue}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          dataAsString,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          orarioAsString,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      isLive
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlinkText(
                                'LIVE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                beginColor: Colors.red,
                                endColor: Colors.white,
                              ),
                            )
                          : Container(),
                      terminata
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Terminata',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class GruppoDetailsColumn extends StatelessWidget {
  const GruppoDetailsColumn({
    Key? key,
    required this.partita,
    required this.logo,
    required this.alignment,
    required this.squadra,
  }) : super(key: key);

  final Partita partita;
  final String logo;
  final String squadra;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                squadra,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: FadeInImage.memoryNetwork(
                  fadeInDuration: Duration(milliseconds: 300),
                  placeholder: kTransparentImage,
                  image: logo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
