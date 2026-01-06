import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Arbre Familial'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @needAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas de compte ? S\'inscrire'**
  String get needAccount;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans votre famille'**
  String get welcomeMessage;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageLabel;

  /// No description provided for @logoutLabel.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logoutLabel;

  /// No description provided for @logoutConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get logoutConfirmation;

  /// No description provided for @cancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelButton;

  /// No description provided for @accountInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations du compte'**
  String get accountInfoTitle;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion'**
  String get loginError;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetPasswordTitle;

  /// No description provided for @enterEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre adresse email'**
  String get enterEmailHint;

  /// No description provided for @sendButton.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get sendButton;

  /// No description provided for @resetEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Email de réinitialisation envoyé'**
  String get resetEmailSent;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get genericError;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour accéder à votre arbre généalogique'**
  String get loginSubtitle;

  /// No description provided for @enterEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre email'**
  String get enterEmailError;

  /// No description provided for @invalidEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un email valide'**
  String get invalidEmailError;

  /// No description provided for @enterPasswordError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get enterPasswordError;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPasswordButton;

  /// No description provided for @notYetAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get notYetAccount;

  /// No description provided for @signupButton.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get signupButton;

  /// No description provided for @registrationSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Inscription réussie ! En attente de validation.'**
  String get registrationSuccess;

  /// No description provided for @registrationError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'inscription'**
  String get registrationError;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get registerTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccountTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte devra être validé par l\'administrateur avant de pouvoir accéder à l\'arbre familial.'**
  String get registerSubtitle;

  /// No description provided for @emailLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Email *'**
  String get emailLabelRequired;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone (optionnel)'**
  String get phoneOptionalLabel;

  /// No description provided for @passwordLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe *'**
  String get passwordLabelRequired;

  /// No description provided for @enterPasswordErrorShort.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un mot de passe'**
  String get enterPasswordErrorShort;

  /// No description provided for @passwordLengthError.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get passwordLengthError;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe *'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez confirmer le mot de passe'**
  String get confirmPasswordError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordMismatchError;

  /// No description provided for @adminApprovalInfo.
  ///
  /// In fr, this message translates to:
  /// **'Après inscription, un administrateur validera votre compte.'**
  String get adminApprovalInfo;

  /// No description provided for @alreadyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get alreadyAccount;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In fr, this message translates to:
  /// **'En attente de validation'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte a été créé avec succès.\n\nUn administrateur doit valider votre inscription avant que vous puissiez accéder à l\'arbre familial.\n\nVous recevrez une notification une fois votre compte approuvé.'**
  String get pendingApprovalMessage;

  /// No description provided for @devBecomeAdmin.
  ///
  /// In fr, this message translates to:
  /// **'(DEV) Devenir Admin'**
  String get devBecomeAdmin;

  /// No description provided for @devAdminSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes maintenant Admin !'**
  String get devAdminSuccess;

  /// No description provided for @navTrees.
  ///
  /// In fr, this message translates to:
  /// **'Arbres'**
  String get navTrees;

  /// No description provided for @navSearch.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get navSearch;

  /// No description provided for @navEvents.
  ///
  /// In fr, this message translates to:
  /// **'Événements'**
  String get navEvents;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @myFamilyTrees.
  ///
  /// In fr, this message translates to:
  /// **'Mes Arbres Familiaux'**
  String get myFamilyTrees;

  /// No description provided for @newTree.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Arbre'**
  String get newTree;

  /// No description provided for @noFamilyTree.
  ///
  /// In fr, this message translates to:
  /// **'Aucun arbre familial'**
  String get noFamilyTree;

  /// No description provided for @createFirstTree.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre premier arbre pour commencer'**
  String get createFirstTree;

  /// No description provided for @createTreeButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer un arbre'**
  String get createTreeButton;

  /// No description provided for @membersCount.
  ///
  /// In fr, this message translates to:
  /// **'membres'**
  String get membersCount;

  /// No description provided for @editAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteAction;

  /// No description provided for @deleteTreeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'arbre'**
  String get deleteTreeTitle;

  /// No description provided for @deleteTreeConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer \"{name}\" et tous ses membres ?\n\nCette action est irréversible.'**
  String deleteTreeConfirmation(Object name);

  /// No description provided for @treeDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Arbre supprimé'**
  String get treeDeleted;

  /// No description provided for @deleteError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la suppression'**
  String get deleteError;

  /// No description provided for @editTreeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'arbre'**
  String get editTreeTitle;

  /// No description provided for @newTreeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Arbre'**
  String get newTreeTitle;

  /// No description provided for @treeNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'arbre *'**
  String get treeNameLabel;

  /// No description provided for @treeNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Famille Cherif'**
  String get treeNameHint;

  /// No description provided for @enterNameError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un nom'**
  String get enterNameError;

  /// No description provided for @nameLengthError.
  ///
  /// In fr, this message translates to:
  /// **'Le nom doit contenir au moins 2 caractères'**
  String get nameLengthError;

  /// No description provided for @descriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Arbre du côté paternel'**
  String get descriptionHint;

  /// No description provided for @saveButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveButton;

  /// No description provided for @createTreeAction.
  ///
  /// In fr, this message translates to:
  /// **'Créer l\'arbre'**
  String get createTreeAction;

  /// No description provided for @treeExpanded.
  ///
  /// In fr, this message translates to:
  /// **'{count} membres'**
  String treeExpanded(Object count);

  /// No description provided for @treeCollapsed.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get treeCollapsed;

  /// No description provided for @adminTitle.
  ///
  /// In fr, this message translates to:
  /// **'Administration'**
  String get adminTitle;

  /// No description provided for @adminPanel.
  ///
  /// In fr, this message translates to:
  /// **'Panel Administrateur'**
  String get adminPanel;

  /// No description provided for @statisticsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statisticsTitle;

  /// No description provided for @quickActionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Actions rapides'**
  String get quickActionsTitle;

  /// No description provided for @manageUsersAction.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des utilisateurs'**
  String get manageUsersAction;

  /// No description provided for @manageUsersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Valider les inscriptions, nommer des modérateurs'**
  String get manageUsersSubtitle;

  /// No description provided for @manageTreesAction.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les arbres'**
  String get manageTreesAction;

  /// No description provided for @manageTreesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un arbre et ajouter des membres'**
  String get manageTreesSubtitle;

  /// No description provided for @createEventAction.
  ///
  /// In fr, this message translates to:
  /// **'Créer un événement'**
  String get createEventAction;

  /// No description provided for @createEventSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Annoncer un mariage, une naissance ou une réunion'**
  String get createEventSubtitle;

  /// No description provided for @membersStat.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get membersStat;

  /// No description provided for @eventsStat.
  ///
  /// In fr, this message translates to:
  /// **'Événements'**
  String get eventsStat;

  /// No description provided for @pendingTab.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pendingTab;

  /// No description provided for @approvedTab.
  ///
  /// In fr, this message translates to:
  /// **'Approuvés'**
  String get approvedTab;

  /// No description provided for @noPendingRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande en attente'**
  String get noPendingRequests;

  /// No description provided for @noApprovedUsers.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur approuvé'**
  String get noApprovedUsers;

  /// No description provided for @approveAction.
  ///
  /// In fr, this message translates to:
  /// **'Approuver'**
  String get approveAction;

  /// No description provided for @rejectAction.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get rejectAction;

  /// No description provided for @confirmRejectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le refus'**
  String get confirmRejectTitle;

  /// No description provided for @confirmRejectMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment refuser et supprimer la demande de {email} ?'**
  String confirmRejectMessage(Object email);

  /// No description provided for @userApprovedMessage.
  ///
  /// In fr, this message translates to:
  /// **'{email} a été approuvé'**
  String userApprovedMessage(Object email);

  /// No description provided for @requestRejectedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Demande refusée'**
  String get requestRejectedMessage;

  /// No description provided for @roleChangedMessage.
  ///
  /// In fr, this message translates to:
  /// **'{email} est maintenant {role}'**
  String roleChangedMessage(Object email, Object role);

  /// No description provided for @roleMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get roleMember;

  /// No description provided for @roleModerator.
  ///
  /// In fr, this message translates to:
  /// **'Modérateur'**
  String get roleModerator;

  /// No description provided for @roleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get roleAdmin;

  /// No description provided for @addMemberTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get addMemberTitle;

  /// No description provided for @identitySection.
  ///
  /// In fr, this message translates to:
  /// **'Identité'**
  String get identitySection;

  /// No description provided for @birthSection.
  ///
  /// In fr, this message translates to:
  /// **'Naissance'**
  String get birthSection;

  /// No description provided for @statusSection.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get statusSection;

  /// No description provided for @parentsSection.
  ///
  /// In fr, this message translates to:
  /// **'Parents (optionnel)'**
  String get parentsSection;

  /// No description provided for @firstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom *'**
  String get firstNameLabel;

  /// No description provided for @fatherNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du père *'**
  String get fatherNameLabel;

  /// No description provided for @grandfatherNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du grand-père *'**
  String get grandfatherNameLabel;

  /// No description provided for @birthPlaceInputLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu de naissance *'**
  String get birthPlaceInputLabel;

  /// No description provided for @deathDateInputLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de décès'**
  String get deathDateInputLabel;

  /// No description provided for @fatherInTreeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Père dans l\'arbre'**
  String get fatherInTreeLabel;

  /// No description provided for @motherInTreeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mère dans l\'arbre'**
  String get motherInTreeLabel;

  /// No description provided for @notesInputLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes (optionnel)'**
  String get notesInputLabel;

  /// No description provided for @addToTreeButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à l\'arbre'**
  String get addToTreeButton;

  /// No description provided for @memberAddedMessage.
  ///
  /// In fr, this message translates to:
  /// **'{name} a été ajouté à l\'arbre'**
  String memberAddedMessage(Object name);

  /// No description provided for @addMemberError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'ajout'**
  String get addMemberError;

  /// No description provided for @firstNameError.
  ///
  /// In fr, this message translates to:
  /// **'Le prénom est obligatoire'**
  String get firstNameError;

  /// No description provided for @fatherNameError.
  ///
  /// In fr, this message translates to:
  /// **'Le nom du père est obligatoire'**
  String get fatherNameError;

  /// No description provided for @grandfatherNameError.
  ///
  /// In fr, this message translates to:
  /// **'Le nom du grand-père est obligatoire'**
  String get grandfatherNameError;

  /// No description provided for @birthPlaceError.
  ///
  /// In fr, this message translates to:
  /// **'Le lieu de naissance est obligatoire'**
  String get birthPlaceError;

  /// No description provided for @genderMale.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In fr, this message translates to:
  /// **'Femme'**
  String get genderFemale;

  /// No description provided for @statusAlive.
  ///
  /// In fr, this message translates to:
  /// **'Vivant'**
  String get statusAlive;

  /// No description provided for @statusDeceased.
  ///
  /// In fr, this message translates to:
  /// **'Décédé'**
  String get statusDeceased;

  /// No description provided for @newEventTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel événement'**
  String get newEventTitle;

  /// No description provided for @eventTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'événement'**
  String get eventTypeLabel;

  /// No description provided for @detailsSection.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get detailsSection;

  /// No description provided for @locationSection.
  ///
  /// In fr, this message translates to:
  /// **'Lieu (optionnel)'**
  String get locationSection;

  /// No description provided for @eventTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre *'**
  String get eventTitleLabel;

  /// No description provided for @eventDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date *'**
  String get eventDateLabel;

  /// No description provided for @eventTimeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Heure (optionnel)'**
  String get eventTimeLabel;

  /// No description provided for @eventLocationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse ou nom du lieu'**
  String get eventLocationLabel;

  /// No description provided for @eventMapsUrlLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lien Google Maps'**
  String get eventMapsUrlLabel;

  /// No description provided for @eventTitleError.
  ///
  /// In fr, this message translates to:
  /// **'Le titre est obligatoire'**
  String get eventTitleError;

  /// No description provided for @eventCreatedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Événement créé avec succès'**
  String get eventCreatedMessage;

  /// No description provided for @eventCreationError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création'**
  String get eventCreationError;

  /// No description provided for @eventNotificationInfo.
  ///
  /// In fr, this message translates to:
  /// **'Tous les membres recevront une notification pour cet événement.'**
  String get eventNotificationInfo;

  /// No description provided for @searchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un membre par nom...'**
  String get searchHint;

  /// No description provided for @familyStatsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques de la famille'**
  String get familyStatsTitle;

  /// No description provided for @totalStat.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get totalStat;

  /// No description provided for @menStat.
  ///
  /// In fr, this message translates to:
  /// **'Hommes'**
  String get menStat;

  /// No description provided for @womenStat.
  ///
  /// In fr, this message translates to:
  /// **'Femmes'**
  String get womenStat;

  /// No description provided for @aliveStat.
  ///
  /// In fr, this message translates to:
  /// **'Vivants'**
  String get aliveStat;

  /// No description provided for @deceasedStat.
  ///
  /// In fr, this message translates to:
  /// **'Décédés'**
  String get deceasedStat;

  /// No description provided for @allMembersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tous les membres'**
  String get allMembersTitle;

  /// No description provided for @noSearchResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé'**
  String get noSearchResults;

  /// No description provided for @searchRetry.
  ///
  /// In fr, this message translates to:
  /// **'Essayez avec un autre nom'**
  String get searchRetry;

  /// No description provided for @eventsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Événements'**
  String get eventsTitle;

  /// No description provided for @newEventButton.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel événement'**
  String get newEventButton;

  /// No description provided for @noEvents.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement'**
  String get noEvents;

  /// No description provided for @noEventsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les événements familiaux apparaîtront ici'**
  String get noEventsSubtitle;

  /// No description provided for @todaySection.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get todaySection;

  /// No description provided for @upcomingSection.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get upcomingSection;

  /// No description provided for @pastSection.
  ///
  /// In fr, this message translates to:
  /// **'Passés'**
  String get pastSection;

  /// No description provided for @timeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get timeLabel;

  /// No description provided for @locationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get locationLabel;

  /// No description provided for @openMapButton.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir dans Google Maps'**
  String get openMapButton;

  /// No description provided for @familyTreeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Arbre Familial'**
  String get familyTreeTitle;

  /// No description provided for @noTreeSelected.
  ///
  /// In fr, this message translates to:
  /// **'Aucun arbre sélectionné'**
  String get noTreeSelected;

  /// No description provided for @resetTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetTooltip;

  /// No description provided for @addMemberButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addMemberButton;

  /// No description provided for @noMembersInTree.
  ///
  /// In fr, this message translates to:
  /// **'Aucun membre dans l\'arbre'**
  String get noMembersInTree;

  /// No description provided for @addFirstMember.
  ///
  /// In fr, this message translates to:
  /// **'Commencez par ajouter le premier membre de la famille.'**
  String get addFirstMember;

  /// No description provided for @noMembersAdmin.
  ///
  /// In fr, this message translates to:
  /// **'L\'administrateur n\'a pas encore ajouté de membres.'**
  String get noMembersAdmin;

  /// No description provided for @addFirstMemberButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter le premier membre'**
  String get addFirstMemberButton;

  /// No description provided for @treeInstructions.
  ///
  /// In fr, this message translates to:
  /// **'Pincez pour zoomer • Faites glisser pour naviguer'**
  String get treeInstructions;

  /// No description provided for @fullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom Complet'**
  String get fullNameLabel;

  /// No description provided for @infoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get infoTitle;

  /// No description provided for @birthDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get birthDateLabel;

  /// No description provided for @birthPlaceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu de naissance'**
  String get birthPlaceLabel;

  /// No description provided for @genderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sexe'**
  String get genderLabel;

  /// No description provided for @siblingRankLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rang dans la fratrie'**
  String get siblingRankLabel;

  /// No description provided for @ageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Âge'**
  String get ageLabel;

  /// No description provided for @yearsSuffix.
  ///
  /// In fr, this message translates to:
  /// **'ans'**
  String get yearsSuffix;

  /// No description provided for @deathDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de décès'**
  String get deathDateLabel;

  /// No description provided for @familyRelationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Liens Familiaux'**
  String get familyRelationsTitle;

  /// No description provided for @fatherLabel.
  ///
  /// In fr, this message translates to:
  /// **'Père'**
  String get fatherLabel;

  /// No description provided for @motherLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mère'**
  String get motherLabel;

  /// No description provided for @wifeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Épouse'**
  String get wifeLabel;

  /// No description provided for @husbandLabel.
  ///
  /// In fr, this message translates to:
  /// **'Époux'**
  String get husbandLabel;

  /// No description provided for @childrenLabel.
  ///
  /// In fr, this message translates to:
  /// **'Enfants'**
  String get childrenLabel;

  /// No description provided for @sonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fils'**
  String get sonLabel;

  /// No description provided for @daughterLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fille'**
  String get daughterLabel;

  /// No description provided for @noRelations.
  ///
  /// In fr, this message translates to:
  /// **'Aucun lien familial enregistré'**
  String get noRelations;

  /// No description provided for @notesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @treeUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Arbre modifié'**
  String get treeUpdated;

  /// No description provided for @treeCreated.
  ///
  /// In fr, this message translates to:
  /// **'Arbre créé avec succès'**
  String get treeCreated;

  /// No description provided for @eventTypeWedding.
  ///
  /// In fr, this message translates to:
  /// **'Mariage'**
  String get eventTypeWedding;

  /// No description provided for @eventTypeBirth.
  ///
  /// In fr, this message translates to:
  /// **'Naissance'**
  String get eventTypeBirth;

  /// No description provided for @eventTypeDeath.
  ///
  /// In fr, this message translates to:
  /// **'Décès'**
  String get eventTypeDeath;

  /// No description provided for @eventTypeReunion.
  ///
  /// In fr, this message translates to:
  /// **'Réunion familiale'**
  String get eventTypeReunion;

  /// No description provided for @eventTypeReligious.
  ///
  /// In fr, this message translates to:
  /// **'Fête religieuse'**
  String get eventTypeReligious;

  /// No description provided for @eventTypeOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get eventTypeOther;

  /// No description provided for @phoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phoneLabel;

  /// No description provided for @statusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get statusLabel;

  /// No description provided for @statusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvé'**
  String get statusApproved;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get statusPending;

  /// No description provided for @linkedMemberTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma fiche dans l\'arbre'**
  String get linkedMemberTitle;

  /// No description provided for @viewFullProfile.
  ///
  /// In fr, this message translates to:
  /// **'Voir ma fiche complète'**
  String get viewFullProfile;

  /// No description provided for @permissionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes permissions'**
  String get permissionsTitle;

  /// No description provided for @permissionViewTree.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'arbre'**
  String get permissionViewTree;

  /// No description provided for @permissionEditMembers.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les membres'**
  String get permissionEditMembers;

  /// No description provided for @permissionCreateEvents.
  ///
  /// In fr, this message translates to:
  /// **'Créer des événements'**
  String get permissionCreateEvents;

  /// No description provided for @permissionManageUsers.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les utilisateurs'**
  String get permissionManageUsers;

  /// No description provided for @logoutAction.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logoutAction;

  /// No description provided for @promotedToAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes maintenant Admin !'**
  String get promotedToAdmin;

  /// No description provided for @notProvided.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get notProvided;

  /// No description provided for @eventTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Mariage de Ahmed et Fatima'**
  String get eventTitleHint;

  /// No description provided for @eventLocationHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Salle des fêtes, Casablanca'**
  String get eventLocationHint;

  /// No description provided for @eventDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Informations supplémentaires...'**
  String get eventDescriptionHint;

  /// No description provided for @eventCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Événement créé avec succès'**
  String get eventCreatedSuccess;

  /// No description provided for @eventCreationErrorDefault.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création'**
  String get eventCreationErrorDefault;

  /// No description provided for @success.
  ///
  /// In fr, this message translates to:
  /// **'Opération réussie'**
  String get success;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
