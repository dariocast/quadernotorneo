import 'package:flutter/material.dart';

import '../../models/gruppo.dart';

class ClassificaWidget extends StatefulWidget {
  final List<Gruppo> gruppiPerGirone;
  ClassificaWidget(this.gruppiPerGirone, {Key? key}) : super(key: key);

  @override
  _ClassificaWidgetState createState() => _ClassificaWidgetState();
}

class _ClassificaWidgetState extends State<ClassificaWidget> {
  int _currentSortColumn = 1;
  bool _isAscending = false;
  @override
  Widget build(BuildContext context) {
    final gruppi = widget.gruppiPerGirone;
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
              sortColumnIndex: _currentSortColumn,
              sortAscending: _isAscending,
              headingRowHeight: 60.0,
              columnSpacing: 5.0,
              headingTextStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              dataRowHeight: 60.0,
              columns: [
                DataColumn(
                    label: Text('Gruppo'),
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.nome.compareTo(a.nome));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.nome.compareTo(b.nome));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('PT'),
                    tooltip: 'Punti',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.pt.compareTo(a.pt));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.pt.compareTo(b.pt));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('PG'),
                    tooltip: 'Partite giocate',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.pg.compareTo(a.pg));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.pg.compareTo(b.pg));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('V'),
                    tooltip: 'Vittorie',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.v.compareTo(a.v));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.v.compareTo(b.v));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('P'),
                    tooltip: 'Pareggi',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.p.compareTo(a.p));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.p.compareTo(b.p));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('S'),
                    tooltip: 'Sconfitte',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.s.compareTo(a.s));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.s.compareTo(b.pt));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('GF'),
                    tooltip: 'Gol fatti',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.gf.compareTo(a.gf));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.gf.compareTo(b.gf));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('GS'),
                    tooltip: 'Gol subiti',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort((a, b) => b.gs.compareTo(a.gs));
                        } else {
                          _isAscending = true;
                          gruppi.sort((a, b) => a.gs.compareTo(b.gs));
                        }
                      });
                    }),
                DataColumn(
                    label: Text('DG'),
                    tooltip: 'Differenza reti',
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          gruppi.sort(
                              (a, b) => (b.gf - b.gs).compareTo((a.gf - a.gs)));
                        } else {
                          _isAscending = true;
                          gruppi.sort(
                              (a, b) => (a.gf - a.gs).compareTo((b.gf - b.gs)));
                        }
                      });
                    }),
                // DataColumn(label: Text('Ultime')),
              ],
              rows: gruppi
                  .map((gruppo) => DataRow(cells: <DataCell>[
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 30.0,
                                height: 50.0,
                                child: Image.network(gruppo.logo)),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                gruppo.nome,
                              ),
                            ),
                          ],
                        )),
                        DataCell(Text(
                          gruppo.pt.toString(),
                          textAlign: TextAlign.center,
                        )),
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
}
