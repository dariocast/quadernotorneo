import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/models/gruppo.dart';

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
              // unselectedItemColor: Colors.white,
            )
          : null,
      body: BlocBuilder<ClassificaBloc, ClassificaState>(
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
          return _landscapeListClassifiche(gruppiPerGirone);
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  ListView _landscapeListClassifiche(List<Gruppo> gruppiPerGirone) {
    return ListView(children: [
      Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: DataTable(
              headingRowHeight: 60.0,
              headingTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              dataRowHeight: 60.0,
              columns: [
                DataColumn(label: Text('Gruppo')),
                DataColumn(label: Text('Punti')),
                DataColumn(label: Text('Partite Giocate')),
                DataColumn(label: Text('Vittorie')),
                DataColumn(label: Text('Pareggi')),
                DataColumn(label: Text('Sconfitte')),
                DataColumn(label: Text('Gol Fatti')),
                DataColumn(label: Text('Gol Subiti')),
                DataColumn(label: Text('Differenza reti')),
                // DataColumn(label: Text('Ultime')),
              ],
              rows: gruppiPerGirone
                  .map((gruppo) => DataRow(cells: <DataCell>[
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Image.network(gruppo.logo)),
                            Text(gruppo.nome),
                          ],
                        )),
                        DataCell(Text(gruppo.pt.toString())),
                        DataCell(Text(gruppo.pg.toString())),
                        DataCell(Text(gruppo.v.toString())),
                        DataCell(Text(gruppo.p.toString())),
                        DataCell(Text(gruppo.s.toString())),
                        DataCell(Text(gruppo.gf.toString())),
                        DataCell(Text(gruppo.gs.toString())),
                        DataCell(Text((gruppo.gf - gruppo.gs).toString())),
                        // DataCell(Text(gruppo.ultime.toString())),
                      ]))
                  .toList(),
            ),
          ),
        ),
      ),
    ]);
  }

  ListView _portraitListClassifiche(List<Gruppo> gruppiPerGirone) {
    return ListView(
      children: [
        Card(
          elevation: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
              child: DataTable(
                headingRowHeight: 60.0,
                headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                dataRowHeight: 60.0,
                columns: [
                  DataColumn(label: Text('Gruppo')),
                  DataColumn(
                    label: Text('Differenza reti'),
                  ),
                  DataColumn(
                    label: Text('Punti'),
                  ),
                ],
                rows: gruppiPerGirone
                    .map(
                      (gruppo) => DataRow(
                        cells: <DataCell>[
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Image.network(gruppo.logo),
                              ),
                              Text(gruppo.nome),
                            ],
                          )),
                          DataCell(Text((gruppo.gf - gruppo.gs).toString())),
                          DataCell(Text(gruppo.pt.toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
