import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quaderno_flutter/blocs/home/home_bloc.dart';

import 'widgets/widgets.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => HomeBloc()..add(HomeStarted()),
        child: HomePage(),
      ),
    );
  }

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeBloc>().state;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Quaderno Torneo',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.circleUser,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.black87,
                )),
          )
        ],
      ),
      body: homeState is HomeLoadSuccess
          ? Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: homeState.tornei.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  homeState.tornei[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Partite',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: homeState.partite.length,
                        itemBuilder: (BuildContext context, int index) {
                          final partita = homeState.partite[index];
                          final logoUno = homeState.gruppi
                              .firstWhere(
                                  (gruppo) => gruppo.nome == partita.squadraUno)
                              .logo;
                          final logoDue = homeState.gruppi
                              .firstWhere(
                                  (gruppo) => gruppo.nome == partita.squadraDue)
                              .logo;
                          return PartitaCard(
                              partita: partita,
                              logoUno: logoUno,
                              logoDue: logoDue);
                        }),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
