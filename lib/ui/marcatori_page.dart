import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/ui/widgets/widgets.dart';
import '../blocs/blocs.dart';

class MarcatoriPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) => MarcatoriBloc()..add(MarcatoriLoaded()),
              child: MarcatoriPage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcatori'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  context.read<MarcatoriBloc>().add(MarcatoriLoaded()),
              icon: Icon(Icons.autorenew_rounded)),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<MarcatoriBloc, MarcatoriState>(builder: (context, state) {
            if (state is MarcatoriLoadFailure) {
              return Center(
                child: Text('Impossibile caricare i marcatori'),
              );
            } else if (state is MarcatoriLoadSuccess) {
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  padding: EdgeInsets.all(5.0),
                  itemCount: state.marcatori.length,
                  itemBuilder: (context, index) {
                    final marcatore = state.marcatori[index];
                    final logoUrl = state.loghi[marcatore.gruppo];
                    return ListTile(
                      leading: Container(
                        child: Image.network(logoUrl!),
                        width: 50,
                        height: 50,
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
