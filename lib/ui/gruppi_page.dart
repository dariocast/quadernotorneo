import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/classifica/classifica_bloc.dart';
import 'package:quaderno_flutter/ui/ui.dart';

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
        body: BlocBuilder<ClassificaBloc, ClassificaState>(
          builder: (context, state) {
            // debugPrint(state.toString());
            if (state is ClassificaLoadSuccess) {
              final gruppi = state.gruppi;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: gruppi.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(GiocatoriPage.route(gruppi[index].nome));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.network(gruppi[index].logo),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${gruppi[index].nome}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
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
        ));
  }
}
