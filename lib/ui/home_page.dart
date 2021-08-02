import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quaderno_flutter/ui/widgets/banner.dart';
import 'package:quaderno_flutter/utils/ad_helper.dart';
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
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
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
          return Stack(
            children: [
              ListView.builder(
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
                                        ..add(DettaglioLoaded(partita)),
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
                                      child: Text(partita.squadraUno,
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
                                  child: Builder(builder: (context) {
                                    initializeDateFormatting('it_IT');
                                    final String dataAsString =
                                        DateFormat.yMMMMd('it_IT')
                                            .format(partita.data);
                                    final String orarioAsString =
                                        DateFormat.Hm().format(partita.data);
                                    final isLive = DateTime.now()
                                            .difference(partita.data)
                                            .inMinutes <=
                                        50;
                                    return Column(
                                      children: [
                                        Text(
                                          '${partita.golSquadraUno} - ${partita.golSquadraDue}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            dataAsString,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Text(
                                            orarioAsString,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ),
                                        isLive
                                            ? BlinkText(
                                                'LIVE',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                beginColor: Colors.red,
                                                endColor: Colors.white,
                                              )
                                            : Container(),
                                      ],
                                    );
                                  }),
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(partita.squadraDue,
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
                  }),
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
                height: 300,
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
              authState.status == AuthenticationStatus.authenticated
                  ? Divider()
                  : Container(),
              authState.status == AuthenticationStatus.authenticated
                  ? Center(
                      child: Text('Gestione'),
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
