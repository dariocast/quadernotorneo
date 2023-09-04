import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/blocs.dart';
import '../models/giocatore.dart';
import '../utils/ui_helpers.dart';
import 'widgets/widgets.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final authState = context.watch<AuthenticationBloc>().state;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${this.gruppo}'),
        centerTitle: true,
        actions: [
          authState.status == AuthenticationStatus.authenticated &&
                  authState.user.isAdmin
              ? IconButton(
                  onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: BlocProvider.of<GiocatoriBloc>(context),
                            child:
                                WidgetParametriGiocatore(gruppo: this.gruppo),
                          );
                        },
                      ),
                  icon: Icon(Icons.person_add_alt_1_rounded))
              : Container(),
          IconButton(
            onPressed: () =>
                context.read<GiocatoriBloc>().add(GiocatoriLoaded()),
            icon: Icon(Icons.autorenew_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<GiocatoriBloc, GiocatoriState>(
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

                return filtered.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: GrigliaGiocatori(
                          giocatori: filtered,
                          key: GlobalKey(),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FaIcon(FontAwesomeIcons.users, size: 30.0),
                            ),
                            Text(
                                AppLocalizations.of(context)!.playerEmptyGroup),
                          ],
                        ),
                      );
              }
            },
          ),
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

class GrigliaGiocatori extends StatefulWidget {
  const GrigliaGiocatori({
    Key? key,
    required this.giocatori,
  }) : super(key: key);

  final List<Giocatore> giocatori;

  @override
  State<GrigliaGiocatori> createState() => _GrigliaGiocatoriState();
}

class _GrigliaGiocatoriState extends State<GrigliaGiocatori> {
  bool deletable = false;

  @override
  Widget build(BuildContext context) {
    final giocatoriBloc = BlocProvider.of<GiocatoriBloc>(context);
    final authState = context.watch<AuthenticationBloc>().state;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 7 / 8,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0),
      itemCount: widget.giocatori.length,
      itemBuilder: (context, index) {
        final giocatore = widget.giocatori.elementAt(index);
        return WillPopScope(
          onWillPop: () async {
            if (!deletable)
              return true;
            else {
              setState(() {
                deletable = !deletable;
              });
            }
            return false;
          },
          child: InkWell(
            onLongPress:
                authState.status == AuthenticationStatus.authenticated &&
                        authState.user.isAdmin
                    ? () => setState(() {
                          deletable = !deletable;
                        })
                    : null,
            onTap: !deletable &&
                    authState.status == AuthenticationStatus.authenticated &&
                    authState.user.isAdmin
                ? () async => await showModalBottomSheet(
                      context: _scaffoldKey.currentContext!,
                      builder: (context) {
                        return BlocProvider.value(
                          value: BlocProvider.of<GiocatoriBloc>(
                              _scaffoldKey.currentContext!),
                          child: WidgetParametriGiocatore(
                            gruppo: giocatore.gruppo,
                            giocatore: giocatore,
                          ),
                        );
                      },
                    )
                : authState.status == AuthenticationStatus.authenticated &&
                        authState.user.isAdmin
                    ? () async {
                        final result = await showOkCancelAlertDialog(
                          context: context,
                          title:
                              AppLocalizations.of(context)!.deleteWarningTitle,
                          message:
                              '${AppLocalizations.of(context)!.playerDeleteLabel} ${giocatore.nome} (${giocatore.gruppo})?',
                        );
                        if (result == OkCancelResult.ok) {
                          giocatoriBloc.add(GiocatoriElimina(giocatore.id));
                        }
                      }
                    : null,
            child: LayoutBuilder(builder: (context, constraint) {
              final heightConstraint = constraint.maxHeight > 200;
              return Card(
                elevation: deletable ? 8 : 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 3.0, right: 5.0, top: 5.0, bottom: 4.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: heightConstraint ? 15.0 : 8,
                        right: heightConstraint ? 20.0 : 10,
                        child: SizedBox(
                          height: heightConstraint ? 150 : 120,
                          child: giocatore.photo == null
                              ? playerImages[giocatore.image]
                              : FadeInImage.memoryNetwork(
                                  fadeInDuration: Duration(milliseconds: 300),
                                  placeholder: kTransparentImage,
                                  image: giocatore.photo!),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            giocatore.nome,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text('${giocatore.gol}'),
                                ),
                                Image.asset(
                                  'assets/images/golfatto.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text('${giocatore.ammonizioni}'),
                                ),
                                Image.asset(
                                  'assets/images/ammonito.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text('${giocatore.espulsioni}'),
                                ),
                                Image.asset(
                                  'assets/images/espulso.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            SizedBox(
                                height: constraint.maxHeight > 200 ? 150 : 80,
                                width: 35,
                                child: playerImages[giocatore.image]),
                          ],
                        ),
                      ),
                      deletable &&
                              authState.status ==
                                  AuthenticationStatus.authenticated &&
                              authState.user.isAdmin
                          ? Positioned(
                              right: 0,
                              top: 0,
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
