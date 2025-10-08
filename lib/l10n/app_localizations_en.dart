// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Quaderno Torneo';

  @override
  String get orderBy => 'Order by';

  @override
  String get matchDateDesc => 'Match date desc';

  @override
  String get matchDateAsc => 'Match date asc';

  @override
  String get matchCreatedDesc => 'Creation date desc';

  @override
  String get matchCreatedAsc => 'Creation date asc';

  @override
  String get matchLoadFailure => 'Unable to load matches at the moment';

  @override
  String get noMatch => 'No matches';

  @override
  String get fullTime => 'Fulltime';

  @override
  String get editNotSavedWarningTitle => 'Are you sure?';

  @override
  String get editNotSavedWarningMessage => 'All unsaved changes will be lost';

  @override
  String get detailPageTitle => 'Match details';

  @override
  String get saveDetailsAlertTitle => 'Save match details?';

  @override
  String get noEditToSaveMessage => 'No changes to save';

  @override
  String get deleteWarningTitle => 'Attention!';

  @override
  String get deleteWarningMessage =>
      'Are you sure you want to remove the match?';

  @override
  String get leaderboardTitle => 'Leaderboards';

  @override
  String get groupLabel => 'Group';

  @override
  String get createButtonLabel => 'Create';

  @override
  String get leaderboardLoadFailure =>
      'Unable to load leaderboards at the moment';

  @override
  String get matchCreateSuccess => 'Match created successfully';

  @override
  String get matchCreateTitle => 'Add match';

  @override
  String get matchCreateGroupSelectionHint => 'Choose team';

  @override
  String get matchCreateDateSelectionHint => 'Select macth day';

  @override
  String get matchCreateDateSelectionButton => 'When?';

  @override
  String get matchCreateTimeSelectionHint => 'Select match time';

  @override
  String get matchCreateTimeSelectionButton => 'What time?';

  @override
  String get matchCreateDescriptionHint => 'Description (optional)';

  @override
  String get matchCreateButton => 'Create';

  @override
  String get matchCreateNoGroupsWarning =>
      'There are no teams!\nAt least one team must exist in the system in order to create a match';

  @override
  String get playerEmptyGroup => 'This team has no players';

  @override
  String get playerDeleteLabel => 'Delete';

  @override
  String get teamCreateTitle => 'Here is a new team';

  @override
  String get teamCreateNameLabel => 'Name';

  @override
  String get teamCreateGroupLabel => 'Group';

  @override
  String get teamCreateUploadLogo => 'Upload logo';

  @override
  String get teamCreateEditLogo => 'Change logo';

  @override
  String get teamCreateCropUploadedImage => 'Crop image';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get teamCreateButton => 'Create';

  @override
  String get noTeams => 'There are no teams in the journal';

  @override
  String get teamPageTitle => 'Teams';

  @override
  String get teamDeleteLabel => 'Delete';

  @override
  String get teamDeleteWithPlayersLabel => 'with all players?';

  @override
  String get teamLoadFailure => 'Unable to load teams at the moment';

  @override
  String get drawerWelcomeLabel => 'Welcome';

  @override
  String get drawerScorersLabel => 'Scorers';

  @override
  String get drawerLeaderboardsLabel => 'Leaderboards';

  @override
  String get drawerTeamsLabel => 'Teams';

  @override
  String get drawerFantasyGameLabel => 'FantaTorneo';

  @override
  String get drawerFantaOpenInBrowser => 'Open in browser';

  @override
  String get drawerFantaOpenInBrowserError => 'Unable to open in browser';

  @override
  String get drawerFantaOpenInApp => 'Open in app';

  @override
  String get drawerManagementLabel => 'Management';

  @override
  String get drawerManagementUpdateScorers => 'Update Scorers';

  @override
  String get drawerManagementUpdateScorersDialogTitle => 'Update Scorers';

  @override
  String get drawerManagementUpdateScorersDialogMessage =>
      'Do you want to update scorers?';

  @override
  String get drawerManagementUpdateLeaderboard => 'Update Leaderboards';

  @override
  String get drawerManagementUpdateLeaderboardDialogTitle =>
      'Update Leaderboards';

  @override
  String get drawerManagementUpdateLeaderboardDialogMessage =>
      'Do you want to update leaderboards?';

  @override
  String get drawerManagementResetLeaderboard => 'Reset Leaderboards';

  @override
  String get drawerManagementResetLeaderboardDialogTitle =>
      'Reset Leaderboards';

  @override
  String get drawerManagementResetLeaderboardDialogMessage =>
      'Leaderboards will be reset, proceed?';

  @override
  String get drawerInfoLabel => 'Info';

  @override
  String get drawerSettingsLabel => 'Settings';

  @override
  String get drawerLogoutButtonLabel => 'Logout';

  @override
  String get drawerLoginButtonLabel => 'Login';

  @override
  String get drawerLogoutDialogTitle => 'Logout';

  @override
  String get drawerLogoutDialogMessage => 'You will be disconnected';

  @override
  String get drawerTournamentLabel => 'Change tournament';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSettingsLabel => 'Language';

  @override
  String get infoPageTitle => 'Info';

  @override
  String get infoPageVersionLabel => 'Version';

  @override
  String get loginAuthFailureMessage =>
      'Authentication failed, check email and password';

  @override
  String get loginRememberMeCheckboxLabel => 'Remember me';

  @override
  String get loginFormEmailLabel => 'Email';

  @override
  String get loginFormEmailErrorLabel => 'Invalid email';

  @override
  String get loginFormPasswordLabel => 'Password';

  @override
  String get loginFormPasswordErrorLabel => 'Invalid password';

  @override
  String get loginFormSubmitLabel => 'Login';

  @override
  String get loginPageTitle => 'Login';

  @override
  String get loginPageSignUpTexButtonLabel => 'Don\'t have an account? Sign up';

  @override
  String get scorersPageTitle => 'Scorers';

  @override
  String get scorersPageLoadFailure => 'Unable to load scorers at the moment';

  @override
  String get scorersPageEmpty => 'Nobody scores yet';

  @override
  String get matchWidgetGolDialogTitle => 'Goal';

  @override
  String get matchWidgetGolDialogMessage => 'Who scored?';

  @override
  String get matchWidgetGolButtonLabel => 'Goal';

  @override
  String get matchWidgetAutogolDialogTitle => 'Autogoal';

  @override
  String get matchWidgetAutogolDialogMessage => 'Who scored?';

  @override
  String get matchWidgetAutogolButtonLabel => 'Autogoal';

  @override
  String get matchWidgetYellowCardDialogTitle => 'Booked';

  @override
  String get matchWidgetYellowCardDialogMessage => 'Who was booked?';

  @override
  String get matchWidgetYellowCardButtonLabel => 'Book';

  @override
  String get matchWidgetRedCardDialogTitle => 'Sent off';

  @override
  String get matchWidgetRedCardDialogMessage => 'Who was sent off?';

  @override
  String get matchWidgetRedCardButtonLabel => 'Send off';

  @override
  String get matchWidgetFoulsLabel => 'Fouls';

  @override
  String get signupPageTitle => 'Sign up';

  @override
  String get signupFailure => 'Error while signing up, retry';

  @override
  String get signupFormUsernameLabel => 'Username';

  @override
  String get signupFormUsernameErrorLabel => 'Insert username';

  @override
  String get signupFormSigninTextButtonLabel =>
      'Already have an account? Login';

  @override
  String get tournamentPageTitle => 'Tournaments';

  @override
  String get tournamentPageEmpty => 'No tournaments';

  @override
  String get tournamentPageLoadFailure =>
      'Unable to load tournaments at the moment';

  @override
  String get tournamentPageAdd => 'Add tournament';

  @override
  String get tournamentPageAddHint => 'Insert tournament name';

  @override
  String get tournamentWidgetEditTitle => 'Edit tournament';

  @override
  String get tournamentWidgetNewTitle => 'New tournament';

  @override
  String get tournamentWidgetNameLabel => 'Name';

  @override
  String get tournamentWidgetEditButtonTitle => 'Edit';

  @override
  String get tournamentWidgetNewButtonTitle => 'Create';

  @override
  String get leaderboardsEmpty => 'No leaderboards';

  @override
  String get leaderboardsPlayedColumnHeader => 'P';

  @override
  String get leaderboardsWinsColumnHeader => 'W';

  @override
  String get leaderboardsDrawsColumnHeader => 'D';

  @override
  String get leaderboardsLossesColumnHeader => 'L';

  @override
  String get leaderboardsPointsColumnHeader => 'Pt';

  @override
  String get leaderboardsPageEmpty => 'No leaderboards';

  @override
  String get liveLabel => 'LIVE';
}
