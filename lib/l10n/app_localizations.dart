import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'Quaderno Torneo'**
  String get appTitle;

  /// No description provided for @orderBy.
  ///
  /// In it, this message translates to:
  /// **'Ordina per'**
  String get orderBy;

  /// No description provided for @matchDateDesc.
  ///
  /// In it, this message translates to:
  /// **'Data partita decrescente'**
  String get matchDateDesc;

  /// No description provided for @matchDateAsc.
  ///
  /// In it, this message translates to:
  /// **'Data partita crescente'**
  String get matchDateAsc;

  /// No description provided for @matchCreatedDesc.
  ///
  /// In it, this message translates to:
  /// **'Data creazione decrescente'**
  String get matchCreatedDesc;

  /// No description provided for @matchCreatedAsc.
  ///
  /// In it, this message translates to:
  /// **'Data creazione crescente'**
  String get matchCreatedAsc;

  /// No description provided for @matchLoadFailure.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare le partite'**
  String get matchLoadFailure;

  /// No description provided for @noMatch.
  ///
  /// In it, this message translates to:
  /// **'Nessuna partita'**
  String get noMatch;

  /// No description provided for @fullTime.
  ///
  /// In it, this message translates to:
  /// **'Terminata'**
  String get fullTime;

  /// No description provided for @editNotSavedWarningTitle.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro?'**
  String get editNotSavedWarningTitle;

  /// No description provided for @editNotSavedWarningMessage.
  ///
  /// In it, this message translates to:
  /// **'Tutte le modifiche non salvate andranno perse'**
  String get editNotSavedWarningMessage;

  /// No description provided for @detailPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Dettaglio incontro'**
  String get detailPageTitle;

  /// No description provided for @saveDetailsAlertTitle.
  ///
  /// In it, this message translates to:
  /// **'Salvare la partita?'**
  String get saveDetailsAlertTitle;

  /// No description provided for @noEditToSaveMessage.
  ///
  /// In it, this message translates to:
  /// **'Nessuna modifica da salvare'**
  String get noEditToSaveMessage;

  /// No description provided for @deleteWarningTitle.
  ///
  /// In it, this message translates to:
  /// **'Attenzione!'**
  String get deleteWarningTitle;

  /// No description provided for @deleteWarningMessage.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler rimuovere la partita?'**
  String get deleteWarningMessage;

  /// No description provided for @leaderboardTitle.
  ///
  /// In it, this message translates to:
  /// **'Classifiche'**
  String get leaderboardTitle;

  /// No description provided for @groupLabel.
  ///
  /// In it, this message translates to:
  /// **'Girone'**
  String get groupLabel;

  /// No description provided for @createButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get createButtonLabel;

  /// No description provided for @leaderboardLoadFailure.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare le classifiche'**
  String get leaderboardLoadFailure;

  /// No description provided for @matchCreateSuccess.
  ///
  /// In it, this message translates to:
  /// **'Partita inserita con successo'**
  String get matchCreateSuccess;

  /// No description provided for @matchCreateTitle.
  ///
  /// In it, this message translates to:
  /// **'Inserisci partita'**
  String get matchCreateTitle;

  /// No description provided for @matchCreateGroupSelectionHint.
  ///
  /// In it, this message translates to:
  /// **'Scegli il gruppo'**
  String get matchCreateGroupSelectionHint;

  /// No description provided for @matchCreateDateSelectionHint.
  ///
  /// In it, this message translates to:
  /// **'Seleziona la data'**
  String get matchCreateDateSelectionHint;

  /// No description provided for @matchCreateDateSelectionButton.
  ///
  /// In it, this message translates to:
  /// **'Che giorno?'**
  String get matchCreateDateSelectionButton;

  /// No description provided for @matchCreateTimeSelectionHint.
  ///
  /// In it, this message translates to:
  /// **'Seleziona la\'orario'**
  String get matchCreateTimeSelectionHint;

  /// No description provided for @matchCreateTimeSelectionButton.
  ///
  /// In it, this message translates to:
  /// **'A che ora?'**
  String get matchCreateTimeSelectionButton;

  /// No description provided for @matchCreateDescriptionHint.
  ///
  /// In it, this message translates to:
  /// **'Descrizione (opzionale)'**
  String get matchCreateDescriptionHint;

  /// No description provided for @matchCreateButton.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get matchCreateButton;

  /// No description provided for @matchCreateNoGroupsWarning.
  ///
  /// In it, this message translates to:
  /// **'Non ci sono gruppi!\nPer poter creare una partita è necessario che almeno un gruppo esista nel sistema'**
  String get matchCreateNoGroupsWarning;

  /// No description provided for @playerEmptyGroup.
  ///
  /// In it, this message translates to:
  /// **'Questo gruppo non ha giocatori'**
  String get playerEmptyGroup;

  /// No description provided for @playerDeleteLabel.
  ///
  /// In it, this message translates to:
  /// **'Eliminare'**
  String get playerDeleteLabel;

  /// No description provided for @teamCreateTitle.
  ///
  /// In it, this message translates to:
  /// **'Un nuovo gruppo, eh?'**
  String get teamCreateTitle;

  /// No description provided for @teamCreateNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get teamCreateNameLabel;

  /// No description provided for @teamCreateGroupLabel.
  ///
  /// In it, this message translates to:
  /// **'Girone'**
  String get teamCreateGroupLabel;

  /// No description provided for @teamCreateUploadLogo.
  ///
  /// In it, this message translates to:
  /// **'Carica un logo'**
  String get teamCreateUploadLogo;

  /// No description provided for @teamCreateEditLogo.
  ///
  /// In it, this message translates to:
  /// **'Cambia logo'**
  String get teamCreateEditLogo;

  /// No description provided for @teamCreateCropUploadedImage.
  ///
  /// In it, this message translates to:
  /// **'Ritaglia l\'immagine'**
  String get teamCreateCropUploadedImage;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancelButtonLabel;

  /// No description provided for @teamCreateButton.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get teamCreateButton;

  /// No description provided for @noTeams.
  ///
  /// In it, this message translates to:
  /// **'Non ci sono gruppi nel quaderno'**
  String get noTeams;

  /// No description provided for @teamPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Gruppi'**
  String get teamPageTitle;

  /// No description provided for @teamDeleteLabel.
  ///
  /// In it, this message translates to:
  /// **'Eliminare'**
  String get teamDeleteLabel;

  /// No description provided for @teamDeleteWithPlayersLabel.
  ///
  /// In it, this message translates to:
  /// **'e tutti i componenti?'**
  String get teamDeleteWithPlayersLabel;

  /// No description provided for @teamLoadFailure.
  ///
  /// In it, this message translates to:
  /// **'C\'è qualche problema a caricare i gruppi'**
  String get teamLoadFailure;

  /// No description provided for @drawerWelcomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto'**
  String get drawerWelcomeLabel;

  /// No description provided for @drawerScorersLabel.
  ///
  /// In it, this message translates to:
  /// **'Marcatori'**
  String get drawerScorersLabel;

  /// No description provided for @drawerLeaderboardsLabel.
  ///
  /// In it, this message translates to:
  /// **'Classifiche'**
  String get drawerLeaderboardsLabel;

  /// No description provided for @drawerTeamsLabel.
  ///
  /// In it, this message translates to:
  /// **'Gruppi'**
  String get drawerTeamsLabel;

  /// No description provided for @drawerFantasyGameLabel.
  ///
  /// In it, this message translates to:
  /// **'FantaTorneo'**
  String get drawerFantasyGameLabel;

  /// No description provided for @drawerFantaOpenInBrowser.
  ///
  /// In it, this message translates to:
  /// **'Apri nel browser'**
  String get drawerFantaOpenInBrowser;

  /// No description provided for @drawerFantaOpenInBrowserError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile aprire nel browser'**
  String get drawerFantaOpenInBrowserError;

  /// No description provided for @drawerFantaOpenInApp.
  ///
  /// In it, this message translates to:
  /// **'Apri nell\'app'**
  String get drawerFantaOpenInApp;

  /// No description provided for @drawerManagementLabel.
  ///
  /// In it, this message translates to:
  /// **'Gestione'**
  String get drawerManagementLabel;

  /// No description provided for @drawerManagementUpdateScorers.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna Marcatori'**
  String get drawerManagementUpdateScorers;

  /// No description provided for @drawerManagementUpdateScorersDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna Marcatori'**
  String get drawerManagementUpdateScorersDialogTitle;

  /// No description provided for @drawerManagementUpdateScorersDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Vuoi aggiornare i marcatori?'**
  String get drawerManagementUpdateScorersDialogMessage;

  /// No description provided for @drawerManagementUpdateLeaderboard.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna Classifica'**
  String get drawerManagementUpdateLeaderboard;

  /// No description provided for @drawerManagementUpdateLeaderboardDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna Classifica'**
  String get drawerManagementUpdateLeaderboardDialogTitle;

  /// No description provided for @drawerManagementUpdateLeaderboardDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Vuoi aggiornare la classifica?'**
  String get drawerManagementUpdateLeaderboardDialogMessage;

  /// No description provided for @drawerManagementResetLeaderboard.
  ///
  /// In it, this message translates to:
  /// **'Reset Classifica'**
  String get drawerManagementResetLeaderboard;

  /// No description provided for @drawerManagementResetLeaderboardDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Reset Classifica'**
  String get drawerManagementResetLeaderboardDialogTitle;

  /// No description provided for @drawerManagementResetLeaderboardDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'La classifica verrà azzerata, continuare?'**
  String get drawerManagementResetLeaderboardDialogMessage;

  /// No description provided for @drawerInfoLabel.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get drawerInfoLabel;

  /// No description provided for @drawerSettingsLabel.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get drawerSettingsLabel;

  /// No description provided for @drawerLogoutButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Logout'**
  String get drawerLogoutButtonLabel;

  /// No description provided for @drawerLoginButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Login'**
  String get drawerLoginButtonLabel;

  /// No description provided for @drawerLogoutDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Logout'**
  String get drawerLogoutDialogTitle;

  /// No description provided for @drawerLogoutDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Sicuro di volerti disconnettere?'**
  String get drawerLogoutDialogMessage;

  /// No description provided for @drawerTournamentLabel.
  ///
  /// In it, this message translates to:
  /// **'Cambia torneo'**
  String get drawerTournamentLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settingsTitle;

  /// No description provided for @languageSettingsLabel.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get languageSettingsLabel;

  /// No description provided for @infoPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get infoPageTitle;

  /// No description provided for @infoPageVersionLabel.
  ///
  /// In it, this message translates to:
  /// **'Versione'**
  String get infoPageVersionLabel;

  /// No description provided for @loginAuthFailureMessage.
  ///
  /// In it, this message translates to:
  /// **'Autenticazione non riuscita, controlla username e password'**
  String get loginAuthFailureMessage;

  /// No description provided for @loginRememberMeCheckboxLabel.
  ///
  /// In it, this message translates to:
  /// **'Ricordami'**
  String get loginRememberMeCheckboxLabel;

  /// No description provided for @loginFormEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get loginFormEmailLabel;

  /// No description provided for @loginFormEmailErrorLabel.
  ///
  /// In it, this message translates to:
  /// **'Email non valida'**
  String get loginFormEmailErrorLabel;

  /// No description provided for @loginFormPasswordLabel.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get loginFormPasswordLabel;

  /// No description provided for @loginFormPasswordErrorLabel.
  ///
  /// In it, this message translates to:
  /// **'Password non valida'**
  String get loginFormPasswordErrorLabel;

  /// No description provided for @loginFormSubmitLabel.
  ///
  /// In it, this message translates to:
  /// **'Login'**
  String get loginFormSubmitLabel;

  /// No description provided for @loginPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Login'**
  String get loginPageTitle;

  /// No description provided for @loginPageSignUpTexButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Non hai un account? Registrati'**
  String get loginPageSignUpTexButtonLabel;

  /// No description provided for @scorersPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Marcatori'**
  String get scorersPageTitle;

  /// No description provided for @scorersPageLoadFailure.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare i marcatori'**
  String get scorersPageLoadFailure;

  /// No description provided for @scorersPageEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuno ha fatto gol'**
  String get scorersPageEmpty;

  /// No description provided for @matchWidgetGolDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Gol'**
  String get matchWidgetGolDialogTitle;

  /// No description provided for @matchWidgetGolDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Chi ha segnato?'**
  String get matchWidgetGolDialogMessage;

  /// No description provided for @matchWidgetGolButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Gol'**
  String get matchWidgetGolButtonLabel;

  /// No description provided for @matchWidgetAutogolDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Autogol'**
  String get matchWidgetAutogolDialogTitle;

  /// No description provided for @matchWidgetAutogolDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Chi l\'ha fatto?'**
  String get matchWidgetAutogolDialogMessage;

  /// No description provided for @matchWidgetAutogolButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Autogol'**
  String get matchWidgetAutogolButtonLabel;

  /// No description provided for @matchWidgetYellowCardDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Ammonito'**
  String get matchWidgetYellowCardDialogTitle;

  /// No description provided for @matchWidgetYellowCardDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Chi è stato ammonito?'**
  String get matchWidgetYellowCardDialogMessage;

  /// No description provided for @matchWidgetYellowCardButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Ammonisci'**
  String get matchWidgetYellowCardButtonLabel;

  /// No description provided for @matchWidgetRedCardDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Espulso'**
  String get matchWidgetRedCardDialogTitle;

  /// No description provided for @matchWidgetRedCardDialogMessage.
  ///
  /// In it, this message translates to:
  /// **'Chi è stato espulso?'**
  String get matchWidgetRedCardDialogMessage;

  /// No description provided for @matchWidgetRedCardButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Espelli'**
  String get matchWidgetRedCardButtonLabel;

  /// No description provided for @matchWidgetFoulsLabel.
  ///
  /// In it, this message translates to:
  /// **'Falli'**
  String get matchWidgetFoulsLabel;

  /// No description provided for @signupPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Registrati'**
  String get signupPageTitle;

  /// No description provided for @signupFailure.
  ///
  /// In it, this message translates to:
  /// **'Errore nella registrazione, riprova'**
  String get signupFailure;

  /// No description provided for @signupFormUsernameLabel.
  ///
  /// In it, this message translates to:
  /// **'Username'**
  String get signupFormUsernameLabel;

  /// No description provided for @signupFormUsernameErrorLabel.
  ///
  /// In it, this message translates to:
  /// **'Inserire una username'**
  String get signupFormUsernameErrorLabel;

  /// No description provided for @signupFormSigninTextButtonLabel.
  ///
  /// In it, this message translates to:
  /// **'Hai già un account? Effettua il login'**
  String get signupFormSigninTextButtonLabel;

  /// No description provided for @tournamentPageTitle.
  ///
  /// In it, this message translates to:
  /// **'Tornei'**
  String get tournamentPageTitle;

  /// No description provided for @tournamentPageEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun torneo'**
  String get tournamentPageEmpty;

  /// No description provided for @tournamentPageLoadFailure.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare i tornei'**
  String get tournamentPageLoadFailure;

  /// No description provided for @tournamentPageAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un torneo'**
  String get tournamentPageAdd;

  /// No description provided for @tournamentPageAddHint.
  ///
  /// In it, this message translates to:
  /// **'Inserisci nome per il nuovo torneo'**
  String get tournamentPageAddHint;

  /// No description provided for @tournamentWidgetEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica torneo'**
  String get tournamentWidgetEditTitle;

  /// No description provided for @tournamentWidgetNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo torneo'**
  String get tournamentWidgetNewTitle;

  /// No description provided for @tournamentWidgetNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get tournamentWidgetNameLabel;

  /// No description provided for @tournamentWidgetEditButtonTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get tournamentWidgetEditButtonTitle;

  /// No description provided for @tournamentWidgetNewButtonTitle.
  ///
  /// In it, this message translates to:
  /// **'Crea'**
  String get tournamentWidgetNewButtonTitle;

  /// No description provided for @leaderboardsEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna classifica'**
  String get leaderboardsEmpty;

  /// No description provided for @leaderboardsPlayedColumnHeader.
  ///
  /// In it, this message translates to:
  /// **'G'**
  String get leaderboardsPlayedColumnHeader;

  /// No description provided for @leaderboardsWinsColumnHeader.
  ///
  /// In it, this message translates to:
  /// **'V'**
  String get leaderboardsWinsColumnHeader;

  /// No description provided for @leaderboardsDrawsColumnHeader.
  ///
  /// In it, this message translates to:
  /// **'P'**
  String get leaderboardsDrawsColumnHeader;

  /// No description provided for @leaderboardsLossesColumnHeader.
  ///
  /// In it, this message translates to:
  /// **'S'**
  String get leaderboardsLossesColumnHeader;

  /// No description provided for @leaderboardsPointsColumnHeader.
  ///
  /// In it, this message translates to:
  /// **'Pt'**
  String get leaderboardsPointsColumnHeader;

  /// No description provided for @leaderboardsPageEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessuna classifica'**
  String get leaderboardsPageEmpty;

  /// No description provided for @liveLabel.
  ///
  /// In it, this message translates to:
  /// **'LIVE'**
  String get liveLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
