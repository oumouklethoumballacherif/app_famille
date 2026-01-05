// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Arbre Familial';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get needAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get welcomeMessage => 'Bienvenue dans votre famille';

  @override
  String get profileTitle => 'Mon Profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get languageLabel => 'Langue';

  @override
  String get logoutLabel => 'Se déconnecter';

  @override
  String get logoutConfirmation => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get accountInfoTitle => 'Informations du compte';

  @override
  String get loginError => 'Erreur de connexion';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get enterEmailHint => 'Entrez votre adresse email';

  @override
  String get sendButton => 'Envoyer';

  @override
  String get resetEmailSent => 'Email de réinitialisation envoyé';

  @override
  String get genericError => 'Erreur';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour accéder à votre arbre généalogique';

  @override
  String get enterEmailError => 'Veuillez entrer votre email';

  @override
  String get invalidEmailError => 'Veuillez entrer un email valide';

  @override
  String get enterPasswordError => 'Veuillez entrer votre mot de passe';

  @override
  String get forgotPasswordButton => 'Mot de passe oublié ?';

  @override
  String get notYetAccount => 'Pas encore de compte ?';

  @override
  String get signupButton => 'S\'inscrire';

  @override
  String get registrationSuccess =>
      'Inscription réussie ! En attente de validation.';

  @override
  String get registrationError => 'Erreur d\'inscription';

  @override
  String get registerTitle => 'Inscription';

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get registerSubtitle =>
      'Votre compte devra être validé par l\'administrateur avant de pouvoir accéder à l\'arbre familial.';

  @override
  String get emailLabelRequired => 'Email *';

  @override
  String get phoneOptionalLabel => 'Téléphone (optionnel)';

  @override
  String get passwordLabelRequired => 'Mot de passe *';

  @override
  String get enterPasswordErrorShort => 'Veuillez entrer un mot de passe';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe *';

  @override
  String get confirmPasswordError => 'Veuillez confirmer le mot de passe';

  @override
  String get passwordMismatchError => 'Les mots de passe ne correspondent pas';

  @override
  String get adminApprovalInfo =>
      'Après inscription, un administrateur validera votre compte.';

  @override
  String get alreadyAccount => 'Déjà un compte ?';

  @override
  String get pendingApprovalTitle => 'En attente de validation';

  @override
  String get pendingApprovalMessage =>
      'Votre compte a été créé avec succès.\n\nUn administrateur doit valider votre inscription avant que vous puissiez accéder à l\'arbre familial.\n\nVous recevrez une notification une fois votre compte approuvé.';

  @override
  String get devBecomeAdmin => '(DEV) Devenir Admin';

  @override
  String get devAdminSuccess => 'Vous êtes maintenant Admin !';

  @override
  String get navTrees => 'Arbres';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navEvents => 'Événements';

  @override
  String get navProfile => 'Profil';

  @override
  String get myFamilyTrees => 'Mes Arbres Familiaux';

  @override
  String get newTree => 'Nouvel Arbre';

  @override
  String get noFamilyTree => 'Aucun arbre familial';

  @override
  String get createFirstTree => 'Créez votre premier arbre pour commencer';

  @override
  String get createTreeButton => 'Créer un arbre';

  @override
  String get membersCount => 'membres';

  @override
  String get editAction => 'Modifier';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get deleteTreeTitle => 'Supprimer l\'arbre';

  @override
  String deleteTreeConfirmation(Object name) {
    return 'Voulez-vous vraiment supprimer \"$name\" et tous ses membres ?\n\nCette action est irréversible.';
  }

  @override
  String get treeDeleted => 'Arbre supprimé';

  @override
  String get deleteError => 'Erreur lors de la suppression';

  @override
  String get editTreeTitle => 'Modifier l\'arbre';

  @override
  String get newTreeTitle => 'Nouvel Arbre';

  @override
  String get treeNameLabel => 'Nom de l\'arbre *';

  @override
  String get treeNameHint => 'Ex: Famille Cherif';

  @override
  String get enterNameError => 'Veuillez entrer un nom';

  @override
  String get nameLengthError => 'Le nom doit contenir au moins 2 caractères';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Ex: Arbre du côté paternel';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get createTreeAction => 'Créer l\'arbre';

  @override
  String treeExpanded(Object count) {
    return '$count membres';
  }

  @override
  String get treeCollapsed => 'Fermer';

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminPanel => 'Panel Administrateur';

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get quickActionsTitle => 'Actions rapides';

  @override
  String get manageUsersAction => 'Gestion des utilisateurs';

  @override
  String get manageUsersSubtitle =>
      'Valider les inscriptions, nommer des modérateurs';

  @override
  String get manageTreesAction => 'Gérer les arbres';

  @override
  String get manageTreesSubtitle => 'Créer un arbre et ajouter des membres';

  @override
  String get createEventAction => 'Créer un événement';

  @override
  String get createEventSubtitle =>
      'Annoncer un mariage, une naissance ou une réunion';

  @override
  String get membersStat => 'Membres';

  @override
  String get eventsStat => 'Événements';

  @override
  String get pendingTab => 'En attente';

  @override
  String get approvedTab => 'Approuvés';

  @override
  String get noPendingRequests => 'Aucune demande en attente';

  @override
  String get noApprovedUsers => 'Aucun utilisateur approuvé';

  @override
  String get approveAction => 'Approuver';

  @override
  String get rejectAction => 'Refuser';

  @override
  String get confirmRejectTitle => 'Confirmer le refus';

  @override
  String confirmRejectMessage(Object email) {
    return 'Voulez-vous vraiment refuser et supprimer la demande de $email ?';
  }

  @override
  String userApprovedMessage(Object email) {
    return '$email a été approuvé';
  }

  @override
  String get requestRejectedMessage => 'Demande refusée';

  @override
  String roleChangedMessage(Object email, Object role) {
    return '$email est maintenant $role';
  }

  @override
  String get roleMember => 'Membre';

  @override
  String get roleModerator => 'Modérateur';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get addMemberTitle => 'Ajouter un membre';

  @override
  String get identitySection => 'Identité';

  @override
  String get birthSection => 'Naissance';

  @override
  String get statusSection => 'Statut';

  @override
  String get parentsSection => 'Parents (optionnel)';

  @override
  String get firstNameLabel => 'Prénom *';

  @override
  String get fatherNameLabel => 'Nom du père *';

  @override
  String get grandfatherNameLabel => 'Nom du grand-père *';

  @override
  String get birthPlaceInputLabel => 'Lieu de naissance *';

  @override
  String get deathDateInputLabel => 'Date de décès';

  @override
  String get fatherInTreeLabel => 'Père dans l\'arbre';

  @override
  String get motherInTreeLabel => 'Mère dans l\'arbre';

  @override
  String get notesInputLabel => 'Notes (optionnel)';

  @override
  String get addToTreeButton => 'Ajouter à l\'arbre';

  @override
  String memberAddedMessage(Object name) {
    return '$name a été ajouté à l\'arbre';
  }

  @override
  String get addMemberError => 'Erreur lors de l\'ajout';

  @override
  String get firstNameError => 'Le prénom est obligatoire';

  @override
  String get fatherNameError => 'Le nom du père est obligatoire';

  @override
  String get grandfatherNameError => 'Le nom du grand-père est obligatoire';

  @override
  String get birthPlaceError => 'Le lieu de naissance est obligatoire';

  @override
  String get genderMale => 'Homme';

  @override
  String get genderFemale => 'Femme';

  @override
  String get statusAlive => 'Vivant';

  @override
  String get statusDeceased => 'Décédé';

  @override
  String get newEventTitle => 'Nouvel événement';

  @override
  String get eventTypeLabel => 'Type d\'événement';

  @override
  String get detailsSection => 'Détails';

  @override
  String get locationSection => 'Lieu (optionnel)';

  @override
  String get eventTitleLabel => 'Titre *';

  @override
  String get eventDateLabel => 'Date *';

  @override
  String get eventTimeLabel => 'Heure (optionnel)';

  @override
  String get eventLocationLabel => 'Adresse ou nom du lieu';

  @override
  String get eventMapsUrlLabel => 'Lien Google Maps';

  @override
  String get eventTitleError => 'Le titre est obligatoire';

  @override
  String get eventCreatedMessage => 'Événement créé avec succès';

  @override
  String get eventCreationError => 'Erreur lors de la création';

  @override
  String get eventNotificationInfo =>
      'Tous les membres recevront une notification pour cet événement.';

  @override
  String get searchTitle => 'Recherche';

  @override
  String get searchHint => 'Rechercher un membre par nom...';

  @override
  String get familyStatsTitle => 'Statistiques de la famille';

  @override
  String get totalStat => 'Total';

  @override
  String get menStat => 'Hommes';

  @override
  String get womenStat => 'Femmes';

  @override
  String get aliveStat => 'Vivants';

  @override
  String get deceasedStat => 'Décédés';

  @override
  String get allMembersTitle => 'Tous les membres';

  @override
  String get noSearchResults => 'Aucun résultat trouvé';

  @override
  String get searchRetry => 'Essayez avec un autre nom';

  @override
  String get eventsTitle => 'Événements';

  @override
  String get newEventButton => 'Nouvel événement';

  @override
  String get noEvents => 'Aucun événement';

  @override
  String get noEventsSubtitle => 'Les événements familiaux apparaîtront ici';

  @override
  String get todaySection => 'Aujourd\'hui';

  @override
  String get upcomingSection => 'À venir';

  @override
  String get pastSection => 'Passés';

  @override
  String get timeLabel => 'Heure';

  @override
  String get locationLabel => 'Lieu';

  @override
  String get openMapButton => 'Ouvrir dans Google Maps';

  @override
  String get familyTreeTitle => 'Arbre Familial';

  @override
  String get noTreeSelected => 'Aucun arbre sélectionné';

  @override
  String get resetTooltip => 'Réinitialiser';

  @override
  String get addMemberButton => 'Ajouter';

  @override
  String get noMembersInTree => 'Aucun membre dans l\'arbre';

  @override
  String get addFirstMember =>
      'Commencez par ajouter le premier membre de la famille.';

  @override
  String get noMembersAdmin =>
      'L\'administrateur n\'a pas encore ajouté de membres.';

  @override
  String get addFirstMemberButton => 'Ajouter le premier membre';

  @override
  String get treeInstructions =>
      'Pincez pour zoomer • Faites glisser pour naviguer';

  @override
  String get fullNameLabel => 'Nom Complet';

  @override
  String get infoTitle => 'Informations';

  @override
  String get birthDateLabel => 'Date de naissance';

  @override
  String get birthPlaceLabel => 'Lieu de naissance';

  @override
  String get genderLabel => 'Sexe';

  @override
  String get siblingRankLabel => 'Rang dans la fratrie';

  @override
  String get ageLabel => 'Âge';

  @override
  String get yearsSuffix => 'ans';

  @override
  String get deathDateLabel => 'Date de décès';

  @override
  String get familyRelationsTitle => 'Liens Familiaux';

  @override
  String get fatherLabel => 'Père';

  @override
  String get motherLabel => 'Mère';

  @override
  String get wifeLabel => 'Épouse';

  @override
  String get husbandLabel => 'Époux';

  @override
  String get childrenLabel => 'Enfants';

  @override
  String get sonLabel => 'Fils';

  @override
  String get daughterLabel => 'Fille';

  @override
  String get noRelations => 'Aucun lien familial enregistré';

  @override
  String get notesTitle => 'Notes';

  @override
  String get treeUpdated => 'Arbre modifié';

  @override
  String get treeCreated => 'Arbre créé avec succès';

  @override
  String get eventTypeWedding => 'Mariage';

  @override
  String get eventTypeBirth => 'Naissance';

  @override
  String get eventTypeDeath => 'Décès';

  @override
  String get eventTypeReunion => 'Réunion familiale';

  @override
  String get eventTypeReligious => 'Fête religieuse';

  @override
  String get eventTypeOther => 'Autre';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get statusLabel => 'Statut';

  @override
  String get statusApproved => 'Approuvé';

  @override
  String get statusPending => 'En attente';

  @override
  String get linkedMemberTitle => 'Ma fiche dans l\'arbre';

  @override
  String get viewFullProfile => 'Voir ma fiche complète';

  @override
  String get permissionsTitle => 'Mes permissions';

  @override
  String get permissionViewTree => 'Voir l\'arbre';

  @override
  String get permissionEditMembers => 'Modifier les membres';

  @override
  String get permissionCreateEvents => 'Créer des événements';

  @override
  String get permissionManageUsers => 'Gérer les utilisateurs';

  @override
  String get logoutAction => 'Se déconnecter';

  @override
  String get promotedToAdmin => 'Vous êtes maintenant Admin !';

  @override
  String get notProvided => 'Non renseigné';

  @override
  String get eventTitleHint => 'Ex: Mariage de Ahmed et Fatima';

  @override
  String get eventLocationHint => 'Ex: Salle des fêtes, Casablanca';

  @override
  String get eventDescriptionHint => 'Informations supplémentaires...';

  @override
  String get eventCreatedSuccess => 'Événement créé avec succès';

  @override
  String get eventCreationErrorDefault => 'Erreur lors de la création';
}
