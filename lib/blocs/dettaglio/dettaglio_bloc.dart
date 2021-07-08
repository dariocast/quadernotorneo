import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/repositories/partita_api_provider.dart';
import 'package:quaderno_flutter/repositories/repository.dart';

part 'dettaglio_event.dart';
part 'dettaglio_state.dart';

class DettaglioBloc extends Bloc<DettaglioEvent, DettaglioState> {
  final _repository = Repository();

  DettaglioBloc() : super(DettaglioState());

  @override
  Stream<DettaglioState> mapEventToState(
    DettaglioEvent event,
  ) async* {
    yield state.copyWith(loading: true);
    if (event is DettaglioLoaded) {
      final giocatoriSquadraUno =
          await _repository.giocatoriGruppo(event.partita.squadraUno);
      final giocatoriSquadraDue =
          await _repository.giocatoriGruppo(event.partita.squadraDue);
      final List<Evento> eventi = List.empty(growable: true);
      event.partita.marcatori.forEach((giocatore) {
        if (giocatore.giocatore.contains(' (Aut)')) {
          eventi.add(Evento(giocatore.giocatore.replaceAll(' (Aut)', ''),
              giocatore.squadra, TipoEvento.AUTOGOL));
        } else {
          eventi.add(
              Evento(giocatore.giocatore, giocatore.squadra, TipoEvento.GOL));
        }
      });
      event.partita.ammoniti.forEach((giocatore) {
        eventi.add(Evento(
            giocatore.giocatore, giocatore.squadra, TipoEvento.AMMONIZIONE));
      });
      event.partita.espulsi.forEach((giocatore) {
        eventi.add(Evento(
            giocatore.giocatore, giocatore.squadra, TipoEvento.ESPULSIONE));
      });
      yield state.copyWith(
        partita: event.partita,
        giocatoriSquadraUno: giocatoriSquadraUno,
        giocatoriSquadraDue: giocatoriSquadraDue,
        eventi: eventi,
        loading: false,
      );
    } else if (event is DettaglioAggiungiGol) {
      final marcatori = state.partita!.marcatori;
      marcatori.add(event.giocatore);
      final partitaAggiornata = state.partita!.copyWith(
        golSquadraUno: event.giocatore.squadra == state.partita!.squadraUno
            ? state.partita!.golSquadraUno + 1
            : state.partita!.golSquadraUno,
        golSquadraDue: event.giocatore.squadra == state.partita!.squadraDue
            ? state.partita!.golSquadraDue + 1
            : state.partita!.golSquadraDue,
        marcatori: marcatori,
      );
      final eventi = state.eventi;
      eventi!.add(Evento(
          event.giocatore.giocatore, event.giocatore.squadra, TipoEvento.GOL));
      yield state.copyWith(
        partita: partitaAggiornata,
        eventi: eventi,
        isEdit: true,
        loading: false,
      );
    } else if (event is DettaglioAggiungiAutogol) {
      final marcatori = state.partita!.marcatori;
      final giocatoreAutogol = event.giocatore
          .copyWith(giocatore: '${event.giocatore.giocatore} (Aut)');
      marcatori.add(giocatoreAutogol);
      final partitaAggiornata = state.partita!.copyWith(
        golSquadraUno: event.giocatore.squadra == state.partita!.squadraUno
            ? state.partita!.golSquadraUno
            : state.partita!.golSquadraUno + 1,
        golSquadraDue: event.giocatore.squadra == state.partita!.squadraDue
            ? state.partita!.golSquadraDue
            : state.partita!.golSquadraDue + 1,
        marcatori: marcatori,
      );
      final eventi = state.eventi;
      eventi!.add(Evento(event.giocatore.giocatore, event.giocatore.squadra,
          TipoEvento.AUTOGOL));
      yield state.copyWith(
        partita: partitaAggiornata,
        eventi: eventi,
        isEdit: true,
        loading: false,
      );
    } else if (event is DettaglioAmmonisci) {
      final ammoniti = state.partita!.ammoniti;
      ammoniti.add(event.giocatore);
      final partitaAggiornata = state.partita!.copyWith(ammoniti: ammoniti);
      final eventi = state.eventi;
      eventi!.add(Evento(event.giocatore.giocatore, event.giocatore.squadra,
          TipoEvento.AMMONIZIONE));
      yield state.copyWith(
        partita: partitaAggiornata,
        eventi: eventi,
        isEdit: true,
        loading: false,
      );
    } else if (event is DettaglioEspelli) {
      final espulsi = state.partita!.espulsi;
      espulsi.add(event.giocatore);
      final partitaAggiornata = state.partita!.copyWith(espulsi: espulsi);
      final eventi = state.eventi;
      eventi!.add(Evento(event.giocatore.giocatore, event.giocatore.squadra,
          TipoEvento.ESPULSIONE));

      yield state.copyWith(
        partita: partitaAggiornata,
        eventi: eventi,
        isEdit: true,
        loading: false,
      );
    } else if (event is DettaglioAggiungiFallo) {
      if (event.squadra == state.partita!.squadraUno) {
        final falli = state.partita!.falliSquadraUno + 1;
        final partita = state.partita!.copyWith(falliSquadraUno: falli);
        yield state.copyWith(
          partita: partita,
          isEdit: true,
          loading: false,
        );
      } else if (event.squadra == state.partita!.squadraDue) {
        final falli = state.partita!.falliSquadraDue + 1;
        final partita = state.partita!.copyWith(falliSquadraDue: falli);
        yield state.copyWith(
          partita: partita,
          isEdit: true,
          loading: false,
        );
      }
    } else if (event is DettaglioRimuoviFallo) {
      if (event.squadra == state.partita!.squadraUno) {
        final falli = state.partita!.falliSquadraUno - 1;
        final partita =
            state.partita!.copyWith(falliSquadraUno: falli >= 0 ? falli : 0);
        yield state.copyWith(
          partita: partita,
          isEdit: true,
          loading: false,
        );
      } else if (event.squadra == state.partita!.squadraDue) {
        final falli = state.partita!.falliSquadraDue - 1;
        final partita =
            state.partita!.copyWith(falliSquadraDue: falli >= 0 ? falli : 0);
        yield state.copyWith(
          partita: partita,
          isEdit: true,
          loading: false,
        );
      }
    } else if (event is DettaglioSalvaPartita) {
      final result = await _repository.aggiornaPartita(state.partita!);
      yield state.copyWith(
        loading: false,
        isEdit: !result,
      );
    } else if (event is DettaglioRimuoviPartita) {
      _repository.eliminaPartita(state.partita!.id);
      yield state.copyWith(partita: null, loading: false);
    } else if (event is DettaglioUndo) {
      final eventi = state.eventi!;
      if (eventi.length == 0) {
        yield state.copyWith(loading: false);
      } else {
        final eventoRimosso = eventi.removeLast();
        if (eventoRimosso.tipo == TipoEvento.GOL) {
          final marcatori = state.partita!.marcatori;
          marcatori.removeWhere((element) =>
              element.giocatore == eventoRimosso.nome &&
              element.squadra == eventoRimosso.squadra);
          final partitaAggiornata = state.partita!.copyWith(
            golSquadraUno: eventoRimosso.squadra == state.partita!.squadraUno
                ? state.partita!.golSquadraUno - 1
                : state.partita!.golSquadraUno,
            golSquadraDue: eventoRimosso.squadra == state.partita!.squadraDue
                ? state.partita!.golSquadraDue - 1
                : state.partita!.golSquadraDue,
            marcatori: marcatori,
          );
          yield state.copyWith(
              partita: partitaAggiornata,
              eventi: eventi,
              isEdit: true,
              loading: false);
        } else if (eventoRimosso.tipo == TipoEvento.AUTOGOL) {
          final marcatori = state.partita!.marcatori;
          marcatori.removeWhere((element) =>
              '${element.giocatore.replaceAll(' (Aut)', '')}' ==
                  eventoRimosso.nome &&
              element.squadra == eventoRimosso.squadra);
          final partitaAggiornata = state.partita!.copyWith(
            golSquadraUno: eventoRimosso.squadra == state.partita!.squadraUno
                ? state.partita!.golSquadraUno
                : state.partita!.golSquadraUno - 1,
            golSquadraDue: eventoRimosso.squadra == state.partita!.squadraDue
                ? state.partita!.golSquadraDue
                : state.partita!.golSquadraDue - 1,
            marcatori: marcatori,
          );
          yield state.copyWith(
              partita: partitaAggiornata,
              eventi: eventi,
              isEdit: true,
              loading: false);
        } else if (eventoRimosso.tipo == TipoEvento.AMMONIZIONE) {
          final ammoniti = state.partita!.ammoniti;
          ammoniti.removeWhere((element) =>
              element.giocatore == eventoRimosso.nome &&
              element.squadra == eventoRimosso.squadra);
          final partitaAggiornata = state.partita!.copyWith(
            ammoniti: ammoniti,
          );
          yield state.copyWith(
              partita: partitaAggiornata,
              eventi: eventi,
              isEdit: true,
              loading: false);
        } else if (eventoRimosso.tipo == TipoEvento.ESPULSIONE) {
          final espulsi = state.partita!.espulsi;
          espulsi.removeWhere((element) =>
              element.giocatore == eventoRimosso.nome &&
              element.squadra == eventoRimosso.squadra);
          final partitaAggiornata = state.partita!.copyWith(
            espulsi: espulsi,
          );
          yield state.copyWith(
              partita: partitaAggiornata,
              eventi: eventi,
              isEdit: true,
              loading: false);
        }
      }
    }
  }
}
