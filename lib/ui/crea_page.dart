import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';

class CreaPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => CreaBloc()..add(CreaLoaded()),
        child: CreaPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreaBloc, CreaState>(
      listener: (context, state) {
        if (state.creationSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text('Partita inserita con successo'),
                duration: Duration(
                  seconds: 3,
                )));
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Inserisci partita'),
          ),
          body: Center(
            child: state.isLoading
                ? CircularProgressIndicator()
                : state.hasGruppi
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              right: 50,
                              left: 50,
                            ),
                            child: DropdownButtonFormField(
                              hint: Text('Scegli il gruppo'),
                              key: const Key(
                                  'creationDialog_gruppoUnoInput_dropdownField'),
                              onChanged: (String? gruppo) {
                                if (gruppo != null) {
                                  context
                                      .read<CreaBloc>()
                                      .add(CreaGruppoUnoChanged(gruppo));
                                }
                              },
                              items: state.gruppi!
                                  .map<DropdownMenuItem<String>>(
                                      (String gruppo) {
                                return DropdownMenuItem(
                                  child: Text(gruppo),
                                  value: gruppo,
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              right: 50,
                              left: 50,
                            ),
                            child: DropdownButtonFormField(
                              hint: Text('Scegli il gruppo'),
                              key: const Key(
                                  'creationDialog_gruppoDueInput_dropdownField'),
                              onChanged: (String? gruppo) {
                                if (gruppo != null) {
                                  context
                                      .read<CreaBloc>()
                                      .add(CreaGruppoDueChanged(gruppo));
                                }
                              },
                              items: state.gruppi!
                                  .map<DropdownMenuItem<String>>(
                                      (String gruppo) {
                                return DropdownMenuItem(
                                  child: Text(gruppo),
                                  value: gruppo,
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 50,
                                  left: 50,
                                ),
                                child: SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2025),
                                        helpText: 'Seleziona la data',
                                      );
                                      if (picked != null) {
                                        context
                                            .read<CreaBloc>()
                                            .add(CreaDataChanged(picked));
                                      }
                                    },
                                    child: Text(
                                      'Che giorno?',
                                    ),
                                  ),
                                ),
                              ),
                              state.data != null
                                  ? Text(
                                      "${state.data?.toLocal()}".split(' ')[0],
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 50,
                                  left: 50,
                                ),
                                child: SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      TimeOfDay? picked = await showTimePicker(
                                        context: context,
                                        helpText: 'Seleziona l\'orario',
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (picked != null) {
                                        context
                                            .read<CreaBloc>()
                                            .add(CreaOrarioChanged(picked));
                                      }
                                    },
                                    child: Text(
                                      'A che ora?',
                                    ),
                                  ),
                                ),
                              ),
                              state.orario != null
                                  ? Text(
                                      "${state.orario?.format(context)}",
                                    )
                                  : Container(),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: ElevatedButton(
                              onPressed: state.isValid
                                  ? () =>
                                      context.read<CreaBloc>().add(CreaSubmit())
                                  : null,
                              child: Text('Crea'),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Non ci sono gruppi!\nPer poter creare una partita è necessario che almeno un gruppo esista nel sistema',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
          ),
        );
      },
    );
  }
}
