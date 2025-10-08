// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';
import '../utils/errors.dart';
import '../utils/log_helper.dart';

class GiocatoreApiProvider {
  Future<List<String>> giocatoriByGruppo(String gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final listaNomi = await supabase
          .from('giocatore')
          .select('nome')
          .eq('gruppo', gruppo) as List;
      final listaNomiSemplice =
          listaNomi.map<String>((entry) => entry['nome']).toList();
      return listaNomiSemplice;
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile ottenere i giocatori: ${error.message}',
          name: 'GiocatoreApiProvider.giocatoriByGruppo');
      throw DatabaseError('Impossibile ottenere i giocatori: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile ottenere i giocatori, errore: $error',
          name: 'GiocatoreApiProvider.giocatoriByGruppo');
      throw AppError('Errore imprevisto durante il caricamento dei giocatori.');
    }
  }

  Future<List<Giocatore>> marcatori(String gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final listaGiocatoriDB = await supabase
          .from('giocatore')
          .select('*')
          .eq('gruppo', gruppo)
          .gt('gol', 0)
          .order('gol', ascending: false);
      final mapDone =
          listaGiocatoriDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      return mapDone.toList();
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile ottenere i marcatori: ${error.message}',
          name: 'GiocatoreApiProvider.marcatori');
      throw DatabaseError('Impossibile ottenere i marcatori: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile ottenere i marcatori, errore: $error',
          name: 'GiocatoreApiProvider.marcatori');
      throw AppError('Errore imprevisto durante il caricamento dei marcatori.');
    }
  }

  Future<Giocatore> creaGiocatore(
      String nome, String gruppo, int immagine, String? photo) async {
    final supabase = Supabase.instance.client;
    try {
      String? publicURL;
      if (photo != null) {
        final logoFile = File(photo);
        final uploadResult = await supabase.storage.from('giocatori').upload(
            '$gruppo$nome${p.extension(photo)}', logoFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true));
        publicURL = supabase.storage
            .from('giocatori')
            .getPublicUrl('$gruppo$nome${p.extension(photo)}');
      }
      final response = await supabase
          .from('giocatore')
          .insert([
            {
              'nome': nome,
              'gruppo': gruppo,
              'image': immagine,
              'photo': publicURL
            }
          ])
          .select()
          .single();
      return Giocatore.fromMap(response);
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile creare nuovo giocatore: ${error.message}',
          name: 'GiocatoreApiProvider.creaGiocatore');
      throw DatabaseError(
          'Impossibile creare nuovo giocatore: ${error.message}');
    } on StorageException catch (error) {
      QTLog.log('Impossibile caricare la foto del giocatore: ${error.message}',
          name: 'GiocatoreApiProvider.creaGiocatore');
      throw NetworkError(
          'Impossibile caricare la foto del giocatore: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile creare nuovo giocatore, errore: $error',
          name: 'GiocatoreApiProvider.creaGiocatore');
      throw AppError('Errore imprevisto durante la creazione del giocatore.');
    }
  }

  Future<bool> aggiorna(Giocatore giocatore, String? newPhoto) async {
    final supabase = Supabase.instance.client;
    try {
      if (newPhoto != null) {
        if (giocatore.photo != null) {
          QTLog.log('Devo rimuovere la vecchia foto dal bucket',
              name: 'repositories.giocatore.update');
          await supabase.storage.from('giocatori').remove([
            '${giocatore.gruppo}${giocatore.nome}${p.extension(giocatore.photo!)}'
          ]);
          QTLog.log('Foto rimossa dal bucket',
              name: 'repositories.giocatore.update');
        }
        QTLog.log('Carico la nuova foto nel bucket',
            name: 'repositories.giocatore.update');
        final logoFile = File(newPhoto);
        await supabase.storage.from('giocatori').upload(
            '${giocatore.gruppo}${giocatore.nome}${p.extension(newPhoto)}',
            logoFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true));
        final publicURL = supabase.storage.from('giocatori').getPublicUrl(
            '${giocatore.gruppo}${giocatore.nome}${p.extension(newPhoto)}');
        QTLog.log('Foto caricata nel bucket',
            name: 'repositories.giocatore.update');
        giocatore = giocatore.copyWith(photo: publicURL);
      }
      await supabase.from('giocatore').update({
        'nome': giocatore.nome,
        'image': giocatore.image,
        'gruppo': giocatore.gruppo,
        'gol': giocatore.gol,
        'ammonizioni': giocatore.ammonizioni,
        'espulsioni': giocatore.espulsioni,
        'photo': giocatore.photo,
      }).eq('id', giocatore.id);
      return true;
    } on PostgrestException catch (error) {
      QTLog.log(
          'Errore durante l\'aggiornamento del giocatore: ${error.message}',
          name: 'repositories.giocatore.update',
          level: Level.SEVERE.value);
      throw DatabaseError(
          'Impossibile aggiornare il giocatore: ${error.message}');
    } on StorageException catch (error) {
      QTLog.log(
          'Errore durante l\'aggiornamento della foto del giocatore: ${error.message}',
          name: 'repositories.giocatore.update',
          level: Level.SEVERE.value);
      throw NetworkError(
          'Impossibile aggiornare la foto del giocatore: ${error.message}');
    } catch (error) {
      QTLog.log('Errore durante l\'aggiornamento: $error',
          name: 'repositories.giocatore.update', level: Level.SEVERE.value);
      throw AppError(
          'Errore imprevisto durante l\'aggiornamento del giocatore.');
    }
  }

  Future<List<Giocatore>> aggiornaTutti(List<Giocatore> giocatori) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('giocatore')
          .upsert(giocatori.map((e) => e.toMap()).toList())
          .select();
      final mapDone =
          response.map<Giocatore>((json) => Giocatore.fromMap(json));
      final List<Giocatore> lista = mapDone.toList();
      lista.sort((a, b) => b.gol.compareTo(a.gol));
      return lista;
    } on PostgrestException catch (error) {
      QTLog.log('Errore nell\'aggiornamento dei marcatori: ${error.message}',
          name: 'GiocatoreApiProvider.aggiornaTutti');
      throw DatabaseError(
          'Impossibile aggiornare i giocatori: ${error.message}');
    } catch (error) {
      QTLog.log('Errore nell\'aggiornamento dei marcatori: $error',
          name: 'GiocatoreApiProvider.aggiornaTutti');
      throw AppError(
          'Errore imprevisto durante l\'aggiornamento dei giocatori.');
    }
  }

  Future<bool> elimina(int id) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('giocatore')
          .delete()
          .eq('id', id)
          .select()
          .single();
      final giocatoreEliminato = Giocatore.fromMap(response);
      QTLog.log('Giocatore rimosso', name: 'repositories.giocatore.delete');
      if (giocatoreEliminato.photo != null) {
        await supabase.storage.from('giocatori').remove([
          '${giocatoreEliminato.gruppo}${giocatoreEliminato.nome}${p.extension(giocatoreEliminato.photo!)}'
        ]);
        QTLog.log('Foto rimossa dal bucket',
            name: 'repositories.giocatore.delete');
      }

      return true;
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile eliminare il giocatore: ${error.message}',
          name: 'repositories.giocatore.delete');
      throw DatabaseError(
          'Impossibile eliminare il giocatore: ${error.message}');
    } on StorageException catch (error) {
      QTLog.log('Impossibile eliminare la foto del giocatore: ${error.message}',
          name: 'repositories.giocatore.delete');
      throw NetworkError(
          'Impossibile eliminare la foto del giocatore: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile eliminare il gruppo, errore: $error',
          name: 'repositories.giocatore.delete');
      throw AppError(
          'Errore imprevisto durante l\'eliminazione del giocatore.');
    }
  }

  Future<List<Giocatore>> tutti() async {
    final supabase = Supabase.instance.client;
    try {
      final listaGruppiDB = await supabase.from('giocatore').select('*');
      final mapDone =
          listaGruppiDB.map<Giocatore>((json) => Giocatore.fromMap(json));
      final lista = mapDone.toList();
      return lista;
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile caricare i giocatori: ${error.message}',
          name: 'GiocatoreApiProvider.tutti');
      throw DatabaseError('Impossibile caricare i giocatori: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile caricare i giocatori, errore: $error',
          name: 'GiocatoreApiProvider.tutti');
      throw AppError('Errore imprevisto durante il caricamento dei giocatori.');
    }
  }

  Future<Giocatore> singolo(String nome, String gruppo) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('giocatore')
          .select('*')
          .eq('nome', nome)
          .eq('gruppo', gruppo)
          .select()
          .single();
      return Giocatore.fromMap(response);
    } on PostgrestException catch (error) {
      QTLog.log('Impossibile caricare $nome gruppo $gruppo: ${error.message}',
          name: 'GiocatoreApiProvider.singolo');
      throw DatabaseError(
          'Impossibile caricare il giocatore: ${error.message}');
    } catch (error) {
      QTLog.log('Impossibile caricare $nome gruppo $gruppo, errore: $error',
          name: 'GiocatoreApiProvider.singolo');
      throw AppError('Errore imprevisto durante il caricamento del giocatore.');
    }
  }
}
