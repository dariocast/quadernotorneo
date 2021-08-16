import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../models/gruppo.dart';
import 'widgets/widgets.dart';

class ClassificaPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
              create: (context) => ClassificaBloc()..add(ClassificaLoaded()),
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
    List<String> gironi;
    if (state is ClassificaLoadSuccess) {
      gironi = state.gruppi.map((gruppo) => gruppo.girone).toSet().toList();
      gironi.sort((a, b) => a.compareTo(b));
    } else {
      gironi = List.empty();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Classifiche'),
        centerTitle: true,
      ),
      bottomNavigationBar: gironi.length >= 2
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: gironi
                  .map((e) => BottomNavigationBarItem(
                      icon: Icon(Icons.flag_rounded),
                      label: "Girone ${e.toUpperCase()}"))
                  .toList(),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : null,
      body: Stack(
        children: [
          BlocBuilder<ClassificaBloc, ClassificaState>(
              builder: (context, state) {
            if (state is ClassificaLoadFailure) {
              return Center(
                child: Text('Impossibile caricare le classifiche'),
              );
            } else if (state is ClassificaLoadSuccess) {
              final gruppiPerGirone = state.gruppi
                  .where((element) => element.girone == gironi[_currentIndex])
                  .toList();
              gruppiPerGirone.sort((a, b) => b.ordinaClassifica(a));
              return ClassificaWidget(gruppiPerGirone);
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
