// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Quaderno Torneo';

  @override
  String get orderBy => 'Ordina per';

  @override
  String get matchDateDesc => 'Data partita decrescente';

  @override
  String get matchDateAsc => 'Data partita crescente';

  @override
  String get matchCreatedDesc => 'Data creazione decrescente';

  @override
  String get matchCreatedAsc => 'Data creazione crescente';

  @override
  String get matchLoadFailure => 'Impossibile caricare le partite';

  @override
  String get noMatch => 'Nessuna partita';

  @override
  String get fullTime => 'Terminata';

  @override
  String get editNotSavedWarningTitle => 'Sei sicuro?';

  @override
  String get editNotSavedWarningMessage =>
      'Tutte le modifiche non salvate andranno perse';

  @override
  String get detailPageTitle => 'Dettaglio incontro';

  @override
  String get saveDetailsAlertTitle => 'Salvare la partita?';

  @override
  String get noEditToSaveMessage => 'Nessuna modifica da salvare';

  @override
  String get deleteWarningTitle => 'Attenzione!';

  @override
  String get deleteWarningMessage =>
      'Sei sicuro di voler rimuovere la partita?';

  @override
  String get leaderboardTitle => 'Classifiche';

  @override
  String get groupLabel => 'Girone';

  @override
  String get createButtonLabel => 'Crea';

  @override
  String get leaderboardLoadFailure => 'Impossibile caricare le classifiche';

  @override
  String get matchCreateSuccess => 'Partita inserita con successo';

  @override
  String get matchCreateTitle => 'Inserisci partita';

  @override
  String get matchCreateGroupSelectionHint => 'Scegli il gruppo';

  @override
  String get matchCreateDateSelectionHint => 'Seleziona la data';

  @override
  String get matchCreateDateSelectionButton => 'Che giorno?';

  @override
  String get matchCreateTimeSelectionHint => 'Seleziona la\'orario';

  @override
  String get matchCreateTimeSelectionButton => 'A che ora?';

  @override
  String get matchCreateDescriptionHint => 'Descrizione (opzionale)';

  @override
  String get matchCreateButton => 'Crea';

  @override
  String get matchCreateNoGroupsWarning =>
      'Non ci sono gruppi!\nPer poter creare una partita è necessario che almeno un gruppo esista nel sistema';

  @override
  String get playerEmptyGroup => 'Questo gruppo non ha giocatori';

  @override
  String get playerDeleteLabel => 'Eliminare';

  @override
  String get teamCreateTitle => 'Un nuovo gruppo, eh?';

  @override
  String get teamCreateNameLabel => 'Nome';

  @override
  String get teamCreateGroupLabel => 'Girone';

  @override
  String get teamCreateUploadLogo => 'Carica un logo';

  @override
  String get teamCreateEditLogo => 'Cambia logo';

  @override
  String get teamCreateCropUploadedImage => 'Ritaglia l\'immagine';

  @override
  String get cancelButtonLabel => 'Annulla';

  @override
  String get teamCreateButton => 'Crea';

  @override
  String get noTeams => 'Non ci sono gruppi nel quaderno';

  @override
  String get teamPageTitle => 'Gruppi';

  @override
  String get teamDeleteLabel => 'Eliminare';

  @override
  String get teamDeleteWithPlayersLabel => 'e tutti i componenti?';

  @override
  String get teamLoadFailure => 'C\'è qualche problema a caricare i gruppi';

  @override
  String get drawerWelcomeLabel => 'Benvenuto';

  @override
  String get drawerScorersLabel => 'Marcatori';

  @override
  String get drawerLeaderboardsLabel => 'Classifiche';

  @override
  String get drawerTeamsLabel => 'Gruppi';

  @override
  String get drawerFantasyGameLabel => 'FantaTorneo';

  @override
  String get drawerFantaOpenInBrowser => 'Apri nel browser';

  @override
  String get drawerFantaOpenInBrowserError => 'Impossibile aprire nel browser';

  @override
  String get drawerFantaOpenInApp => 'Apri nell\'app';

  @override
  String get drawerManagementLabel => 'Gestione';

  @override
  String get drawerManagementUpdateScorers => 'Aggiorna Marcatori';

  @override
  String get drawerManagementUpdateScorersDialogTitle => 'Aggiorna Marcatori';

  @override
  String get drawerManagementUpdateScorersDialogMessage =>
      'Vuoi aggiornare i marcatori?';

  @override
  String get drawerManagementUpdateLeaderboard => 'Aggiorna Classifica';

  @override
  String get drawerManagementUpdateLeaderboardDialogTitle =>
      'Aggiorna Classifica';

  @override
  String get drawerManagementUpdateLeaderboardDialogMessage =>
      'Vuoi aggiornare la classifica?';

  @override
  String get drawerManagementResetLeaderboard => 'Reset Classifica';

  @override
  String get drawerManagementResetLeaderboardDialogTitle => 'Reset Classifica';

  @override
  String get drawerManagementResetLeaderboardDialogMessage =>
      'La classifica verrà azzerata, continuare?';

  @override
  String get drawerInfoLabel => 'Informazioni';

  @override
  String get drawerSettingsLabel => 'Impostazioni';

  @override
  String get drawerLogoutButtonLabel => 'Logout';

  @override
  String get drawerLoginButtonLabel => 'Login';

  @override
  String get drawerLogoutDialogTitle => 'Logout';

  @override
  String get drawerLogoutDialogMessage => 'Sicuro di volerti disconnettere?';

  @override
  String get drawerTournamentLabel => 'Cambia torneo';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get languageSettingsLabel => 'Lingua';

  @override
  String get infoPageTitle => 'Informazioni';

  @override
  String get infoPageVersionLabel => 'Versione';

  @override
  String get loginAuthFailureMessage =>
      'Autenticazione non riuscita, controlla username e password';

  @override
  String get loginRememberMeCheckboxLabel => 'Ricordami';

  @override
  String get loginFormEmailLabel => 'Email';

  @override
  String get loginFormEmailErrorLabel => 'Email non valida';

  @override
  String get loginFormPasswordLabel => 'Password';

  @override
  String get loginFormPasswordErrorLabel => 'Password non valida';

  @override
  String get loginFormSubmitLabel => 'Login';

  @override
  String get loginPageTitle => 'Login';

  @override
  String get loginPageSignUpTexButtonLabel => 'Non hai un account? Registrati';

  @override
  String get scorersPageTitle => 'Marcatori';

  @override
  String get scorersPageLoadFailure => 'Impossibile caricare i marcatori';

  @override
  String get scorersPageEmpty => 'Nessuno ha fatto gol';

  @override
  String get matchWidgetGolDialogTitle => 'Gol';

  @override
  String get matchWidgetGolDialogMessage => 'Chi ha segnato?';

  @override
  String get matchWidgetGolButtonLabel => 'Gol';

  @override
  String get matchWidgetAutogolDialogTitle => 'Autogol';

  @override
  String get matchWidgetAutogolDialogMessage => 'Chi l\'ha fatto?';

  @override
  String get matchWidgetAutogolButtonLabel => 'Autogol';

  @override
  String get matchWidgetYellowCardDialogTitle => 'Ammonito';

  @override
  String get matchWidgetYellowCardDialogMessage => 'Chi è stato ammonito?';

  @override
  String get matchWidgetYellowCardButtonLabel => 'Ammonisci';

  @override
  String get matchWidgetRedCardDialogTitle => 'Espulso';

  @override
  String get matchWidgetRedCardDialogMessage => 'Chi è stato espulso?';

  @override
  String get matchWidgetRedCardButtonLabel => 'Espelli';

  @override
  String get matchWidgetFoulsLabel => 'Falli';

  @override
  String get signupPageTitle => 'Registrati';

  @override
  String get signupFailure => 'Errore nella registrazione, riprova';

  @override
  String get signupFormUsernameLabel => 'Username';

  @override
  String get signupFormUsernameErrorLabel => 'Inserire una username';

  @override
  String get signupFormSigninTextButtonLabel =>
      'Hai già un account? Effettua il login';

  @override
  String get tournamentPageTitle => 'Tornei';

  @override
  String get tournamentPageEmpty => 'Nessun torneo';

  @override
  String get tournamentPageLoadFailure => 'Impossibile caricare i tornei';

  @override
  String get tournamentPageAdd => 'Aggiungi un torneo';

  @override
  String get tournamentPageAddHint => 'Inserisci nome per il nuovo torneo';

  @override
  String get tournamentWidgetEditTitle => 'Modifica torneo';

  @override
  String get tournamentWidgetNewTitle => 'Nuovo torneo';

  @override
  String get tournamentWidgetNameLabel => 'Nome';

  @override
  String get tournamentWidgetEditButtonTitle => 'Modifica';

  @override
  String get tournamentWidgetNewButtonTitle => 'Crea';

  @override
  String get leaderboardsEmpty => 'Nessuna classifica';

  @override
  String get leaderboardsPlayedColumnHeader => 'G';

  @override
  String get leaderboardsWinsColumnHeader => 'V';

  @override
  String get leaderboardsDrawsColumnHeader => 'P';

  @override
  String get leaderboardsLossesColumnHeader => 'S';

  @override
  String get leaderboardsPointsColumnHeader => 'Pt';

  @override
  String get leaderboardsPageEmpty => 'Nessuna classifica';

  @override
  String get liveLabel => 'LIVE';
}
