import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/classifica/classifica_bloc.dart';
import 'package:quaderno_flutter/ui/ui.dart';
import 'package:quaderno_flutter/ui/widgets/widgets.dart';

class GruppiPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) => ClassificaBloc()..add(ClassificaLoaded()),
              child: GruppiPage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gruppi'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            BlocBuilder<ClassificaBloc, ClassificaState>(
              builder: (context, state) {
                // debugPrint(state.toString());
                if (state is ClassificaLoadSuccess) {
                  final gruppi = state.gruppi;
                  gruppi.sort((a, b) => a.nome.compareTo(b.nome));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            childAspectRatio: 1 / 1,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0),
                        itemCount: gruppi.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      GiocatoriPage.route(gruppi[index].nome));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.network(gruppi[index].logo),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${gruppi[index].nome}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else if (state is ClassificaLoadFailure) {
                  return Center(
                    child: Text('C\'è qualche problema a caricare i gruppi'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 5.0,
              child: QuadernoBannerAd(),
            ),
          ],
        ));
  }
}
