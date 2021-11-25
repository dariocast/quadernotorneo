import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../repositories/partita_api_provider.dart';
import '../../repositories/repository.dart';

part 'dettaglio_event.dart';
part 'dettaglio_state.dart';

class DettaglioBloc extends Bloc<DettaglioEvent, DettaglioState> {
  final _repository = Repository();

  DettaglioBloc() : super(DettaglioState()) {
    on<DettaglioLoaded>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioLoadedEvent(event, emit);
    });
    on<DettaglioAggiungiGol>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioAggiungiGolEvent(event, emit);
    });
    on<DettaglioAggiungiAutogol>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioAggiungiAutogolEvent(event, emit);
    });
    on<DettaglioAmmonisci>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioAmmonisciEvent(event, emit);
    });
    on<DettaglioEspelli>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioEspelliEvent(event, emit);
    });
    on<DettaglioAggiungiFallo>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioAggiungiFalloEvent(event, emit);
    });
    on<DettaglioRimuoviFallo>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioRimuoviFalloEvent(event, emit);
    });

    // Handler for Salva and for Rimuovi partita are inline because are simple
    on<DettaglioSalvaPartita>((event, emit) async {
      emit(state.copyWith(loading: true));
      final result = await _repository.aggiornaPartita(state.partita!);
      emit(state.copyWith(
        loading: false,
        isEdit: !result,
      ));
    });
    on<DettaglioRimuoviPartita>((event, emit) {
      emit(state.copyWith(loading: true));
      _repository.eliminaPartita(state.partita!.id);
      emit(state.copyWith(partita: null, loading: false));
    });

    on<DettaglioUndo>((event, emit) {
      emit(state.copyWith(loading: true));
      _handleDettaglioUndoEvent(event, emit);
    });
  }

  _handleDettaglioLoadedEvent(
      DettaglioLoaded event, Emitter<DettaglioState> emit) async {
    final giocatoriSquadraUno =
        await _repository.giocatoriGruppo(event.partita.squadraUno);
    final giocatoriSquadraDue =
        await _repository.giocatoriGruppo(event.partita.squadraDue);
    final List<Evento> eventi = List.empty(growable: true);
    event.partita.marcatori.forEach((giocatore) {
      if (giocatore.nome.contains(' (Aut)')) {
        eventi.add(Evento(giocatore.nome.replaceAll(' (Aut)', ''),
            giocatore.gruppo, TipoEvento.AUTOGOL));
      } else {
        eventi.add(Evento(giocatore.nome, giocatore.gruppo, TipoEvento.GOL));
      }
    });
    event.partita.ammoniti.forEach((giocatore) {
      eventi.add(
          Evento(giocatore.nome, giocatore.gruppo, TipoEvento.AMMONIZIONE));
    });
    event.partita.espulsi.forEach((giocatore) {
      eventi
          .add(Evento(giocatore.nome, giocatore.gruppo, TipoEvento.ESPULSIONE));
    });
    emit(state.copyWith(
      partita: event.partita,
      giocatoriSquadraUno: giocatoriSquadraUno,
      giocatoriSquadraDue: giocatoriSquadraDue,
      eventi: eventi,
      loading: false,
    ));
  }

  _handleDettaglioAggiungiGolEvent(
      DettaglioAggiungiGol event, Emitter<DettaglioState> emit) {
    final marcatori = state.partita!.marcatori;
    marcatori.add(event.giocatore);
    final partitaAggiornata = state.partita!.copyWith(
      golSquadraUno: event.giocatore.gruppo == state.partita!.squadraUno
          ? state.partita!.golSquadraUno + 1
          : state.partita!.golSquadraUno,
      golSquadraDue: event.giocatore.gruppo == state.partita!.squadraDue
          ? state.partita!.golSquadraDue + 1
          : state.partita!.golSquadraDue,
      marcatori: marcatori,
    );
    final eventi = state.eventi;
    eventi!.add(
        Evento(event.giocatore.nome, event.giocatore.gruppo, TipoEvento.GOL));
    emit(state.copyWith(
      partita: partitaAggiornata,
      eventi: eventi,
      isEdit: true,
      loading: false,
    ));
  }

  void _handleDettaglioAggiungiAutogolEvent(
      DettaglioAggiungiAutogol event, Emitter<DettaglioState> emit) {
    final marcatori = state.partita!.marcatori;
    final giocatoreAutogol =
        event.giocatore.copyWith(nome: '${event.giocatore.nome} (Aut)');
    marcatori.add(giocatoreAutogol);
    final partitaAggiornata = state.partita!.copyWith(
      golSquadraUno: event.giocatore.gruppo == state.partita!.squadraUno
          ? state.partita!.golSquadraUno
          : state.partita!.golSquadraUno + 1,
      golSquadraDue: event.giocatore.gruppo == state.partita!.squadraDue
          ? state.partita!.golSquadraDue
          : state.partita!.golSquadraDue + 1,
      marcatori: marcatori,
    );
    final eventi = state.eventi;
    eventi!.add(Evento(
        event.giocatore.nome, event.giocatore.gruppo, TipoEvento.AUTOGOL));
    emit(state.copyWith(
      partita: partitaAggiornata,
      eventi: eventi,
      isEdit: true,
      loading: false,
    ));
  }

  void _handleDettaglioAmmonisciEvent(
      DettaglioAmmonisci event, Emitter<DettaglioState> emit) {
    final ammoniti = state.partita!.ammoniti;
    ammoniti.add(event.giocatore);
    final partitaAggiornata = state.partita!.copyWith(ammoniti: ammoniti);
    final eventi = state.eventi;
    eventi!.add(Evento(
        event.giocatore.nome, event.giocatore.gruppo, TipoEvento.AMMONIZIONE));
    emit(state.copyWith(
      partita: partitaAggiornata,
      eventi: eventi,
      isEdit: true,
      loading: false,
    ));
  }

  void _handleDettaglioEspelliEvent(
      DettaglioEspelli event, Emitter<DettaglioState> emit) {
    final espulsi = state.partita!.espulsi;
    espulsi.add(event.giocatore);
    final partitaAggiornata = state.partita!.copyWith(espulsi: espulsi);
    final eventi = state.eventi;
    eventi!.add(Evento(
        event.giocatore.nome, event.giocatore.gruppo, TipoEvento.ESPULSIONE));

    emit(state.copyWith(
      partita: partitaAggiornata,
      eventi: eventi,
      isEdit: true,
      loading: false,
    ));
  }

  void _handleDettaglioAggiungiFalloEvent(
      DettaglioAggiungiFallo event, Emitter<DettaglioState> emit) {
    if (event.squadra == state.partita!.squadraUno) {
      final falli = state.partita!.falliSquadraUno + 1;
      final partita = state.partita!.copyWith(falliSquadraUno: falli);
      emit(state.copyWith(
        partita: partita,
        isEdit: true,
        loading: false,
      ));
    } else if (event.squadra == state.partita!.squadraDue) {
      final falli = state.partita!.falliSquadraDue + 1;
      final partita = state.partita!.copyWith(falliSquadraDue: falli);
      emit(state.copyWith(
        partita: partita,
        isEdit: true,
        loading: false,
      ));
    }
  }

  void _handleDettaglioRimuoviFalloEvent(
      DettaglioRimuoviFallo event, Emitter<DettaglioState> emit) {
    if (event.squadra == state.partita!.squadraUno) {
      final falli = state.partita!.falliSquadraUno - 1;
      final partita =
          state.partita!.copyWith(falliSquadraUno: falli >= 0 ? falli : 0);
      emit(state.copyWith(
        partita: partita,
        isEdit: true,
        loading: false,
      ));
    } else if (event.squadra == state.partita!.squadraDue) {
      final falli = state.partita!.falliSquadraDue - 1;
      final partita =
          state.partita!.copyWith(falliSquadraDue: falli >= 0 ? falli : 0);
      emit(state.copyWith(
        partita: partita,
        isEdit: true,
        loading: false,
      ));
    }
  }

  void _handleDettaglioUndoEvent(
      DettaglioUndo event, Emitter<DettaglioState> emit) {
    final eventi = state.eventi!;
    if (eventi.length == 0) {
      emit(state.copyWith(loading: false));
    } else {
      final eventoRimosso = eventi.removeLast();
      if (eventoRimosso.tipo == TipoEvento.GOL) {
        final marcatori = state.partita!.marcatori;
        marcatori.removeWhere((element) =>
            element.nome == eventoRimosso.nome &&
            element.gruppo == eventoRimosso.squadra);
        final partitaAggiornata = state.partita!.copyWith(
          golSquadraUno: eventoRimosso.squadra == state.partita!.squadraUno
              ? state.partita!.golSquadraUno - 1
              : state.partita!.golSquadraUno,
          golSquadraDue: eventoRimosso.squadra == state.partita!.squadraDue
              ? state.partita!.golSquadraDue - 1
              : state.partita!.golSquadraDue,
          marcatori: marcatori,
        );
        emit(state.copyWith(
            partita: partitaAggiornata,
            eventi: eventi,
            isEdit: true,
            loading: false));
      } else if (eventoRimosso.tipo == TipoEvento.AUTOGOL) {
        final marcatori = state.partita!.marcatori;
        marcatori.removeWhere((element) =>
            '${element.nome.replaceAll(' (Aut)', '')}' == eventoRimosso.nome &&
            element.gruppo == eventoRimosso.squadra);
        final partitaAggiornata = state.partita!.copyWith(
          golSquadraUno: eventoRimosso.squadra == state.partita!.squadraUno
              ? state.partita!.golSquadraUno
              : state.partita!.golSquadraUno - 1,
          golSquadraDue: eventoRimosso.squadra == state.partita!.squadraDue
              ? state.partita!.golSquadraDue
              : state.partita!.golSquadraDue - 1,
          marcatori: marcatori,
        );
        emit(state.copyWith(
            partita: partitaAggiornata,
            eventi: eventi,
            isEdit: true,
            loading: false));
      } else if (eventoRimosso.tipo == TipoEvento.AMMONIZIONE) {
        final ammoniti = state.partita!.ammoniti;
        ammoniti.removeWhere((element) =>
            element.nome == eventoRimosso.nome &&
            element.gruppo == eventoRimosso.squadra);
        final partitaAggiornata = state.partita!.copyWith(
          ammoniti: ammoniti,
        );
        emit(state.copyWith(
            partita: partitaAggiornata,
            eventi: eventi,
            isEdit: true,
            loading: false));
      } else if (eventoRimosso.tipo == TipoEvento.ESPULSIONE) {
        final espulsi = state.partita!.espulsi;
        espulsi.removeWhere((element) =>
            element.nome == eventoRimosso.nome &&
            element.gruppo == eventoRimosso.squadra);
        final partitaAggiornata = state.partita!.copyWith(
          espulsi: espulsi,
        );
        emit(state.copyWith(
            partita: partitaAggiornata,
            eventi: eventi,
            isEdit: true,
            loading: false));
      }
    }
  }
}
