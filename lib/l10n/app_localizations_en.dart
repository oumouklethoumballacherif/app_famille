// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Tree';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get needAccount => 'No account? Sign up';

  @override
  String get welcomeMessage => 'Welcome to your family';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get logoutLabel => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get accountInfoTitle => 'Account Information';

  @override
  String get loginError => 'Login Error';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get enterEmailHint => 'Enter your email address';

  @override
  String get sendButton => 'Send';

  @override
  String get resetEmailSent => 'Reset email sent';

  @override
  String get genericError => 'Error';

  @override
  String get loginSubtitle => 'Log in to access your family tree';

  @override
  String get enterEmailError => 'Please enter your email';

  @override
  String get invalidEmailError => 'Please enter a valid email';

  @override
  String get enterPasswordError => 'Please enter your password';

  @override
  String get forgotPasswordButton => 'Forgot password?';

  @override
  String get notYetAccount => 'No account yet?';

  @override
  String get signupButton => 'Sign up';

  @override
  String get registrationSuccess =>
      'Registration successful! Waiting for validation.';

  @override
  String get registrationError => 'Registration Error';

  @override
  String get registerTitle => 'Register';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get registerSubtitle =>
      'Your account must be validated by an administrator before you can access the family tree.';

  @override
  String get emailLabelRequired => 'Email *';

  @override
  String get phoneOptionalLabel => 'Phone (optional)';

  @override
  String get passwordLabelRequired => 'Password *';

  @override
  String get enterPasswordErrorShort => 'Please enter a password';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordLabel => 'Confirm Password *';

  @override
  String get confirmPasswordError => 'Please confirm your password';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get adminApprovalInfo =>
      'After registration, an administrator will validate your account.';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get pendingApprovalTitle => 'Pending Validation';

  @override
  String get pendingApprovalMessage =>
      'Your account has been created successfully.\n\nAn administrator must validate your registration before you can access the family tree.\n\nYou will receive a notification once your account is approved.';

  @override
  String get devBecomeAdmin => '(DEV) Become Admin';

  @override
  String get devAdminSuccess => 'You are now Admin!';

  @override
  String get navTrees => 'Trees';

  @override
  String get navSearch => 'Search';

  @override
  String get navEvents => 'Events';

  @override
  String get navProfile => 'Profile';

  @override
  String get myFamilyTrees => 'My Family Trees';

  @override
  String get newTree => 'New Tree';

  @override
  String get noFamilyTree => 'No family tree';

  @override
  String get createFirstTree => 'Create your first tree to get started';

  @override
  String get createTreeButton => 'Create tree';

  @override
  String get membersCount => 'members';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteTreeTitle => 'Delete Tree';

  @override
  String deleteTreeConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\" and all its members?\n\nThis action is irreversible.';
  }

  @override
  String get treeDeleted => 'Tree deleted';

  @override
  String get deleteError => 'Error deleting tree';

  @override
  String get editTreeTitle => 'Edit Tree';

  @override
  String get newTreeTitle => 'New Tree';

  @override
  String get treeNameLabel => 'Tree Name *';

  @override
  String get treeNameHint => 'Ex: Cherif Family';

  @override
  String get enterNameError => 'Please enter a name';

  @override
  String get nameLengthError => 'Name must be at least 2 characters';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Ex: Paternal side tree';

  @override
  String get saveButton => 'Save';

  @override
  String get createTreeAction => 'Create Tree';

  @override
  String treeExpanded(Object count) {
    return '$count members';
  }

  @override
  String get treeCollapsed => 'Close';

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get quickActionsTitle => 'Quick Actions';

  @override
  String get manageUsersAction => 'User Management';

  @override
  String get manageUsersSubtitle =>
      'Validate registrations, appoint moderators';

  @override
  String get manageTreesAction => 'Manage Trees';

  @override
  String get manageTreesSubtitle => 'Create trees and add members';

  @override
  String get createEventAction => 'Create Event';

  @override
  String get createEventSubtitle => 'Announce a wedding, birth, or reunion';

  @override
  String get membersStat => 'Members';

  @override
  String get eventsStat => 'Events';

  @override
  String get pendingTab => 'Pending';

  @override
  String get approvedTab => 'Approved';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get noApprovedUsers => 'No approved users';

  @override
  String get approveAction => 'Approve';

  @override
  String get rejectAction => 'Reject';

  @override
  String get confirmRejectTitle => 'Confirm Rejection';

  @override
  String confirmRejectMessage(Object email) {
    return 'Do you really want to reject and delete the request for $email?';
  }

  @override
  String userApprovedMessage(Object email) {
    return '$email has been approved';
  }

  @override
  String get requestRejectedMessage => 'Request rejected';

  @override
  String roleChangedMessage(Object email, Object role) {
    return '$email is now $role';
  }

  @override
  String get roleMember => 'Member';

  @override
  String get roleModerator => 'Moderator';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get addMemberTitle => 'Add Member';

  @override
  String get identitySection => 'Identity';

  @override
  String get birthSection => 'Birth';

  @override
  String get statusSection => 'Status';

  @override
  String get parentsSection => 'Parents (Optional)';

  @override
  String get firstNameLabel => 'First Name *';

  @override
  String get fatherNameLabel => 'Father\'s Name *';

  @override
  String get grandfatherNameLabel => 'Grandfather\'s Name *';

  @override
  String get birthPlaceInputLabel => 'Birth Place *';

  @override
  String get deathDateInputLabel => 'Death Date';

  @override
  String get fatherInTreeLabel => 'Father in Tree';

  @override
  String get motherInTreeLabel => 'Mother in Tree';

  @override
  String get notesInputLabel => 'Notes (Optional)';

  @override
  String get addToTreeButton => 'Add to Tree';

  @override
  String memberAddedMessage(Object name) {
    return '$name was added to the tree';
  }

  @override
  String get addMemberError => 'Error adding member';

  @override
  String get firstNameError => 'First name is required';

  @override
  String get fatherNameError => 'Father\'s name is required';

  @override
  String get grandfatherNameError => 'Grandfather\'s name is required';

  @override
  String get birthPlaceError => 'Birth place is required';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get statusAlive => 'Alive';

  @override
  String get statusDeceased => 'Deceased';

  @override
  String get newEventTitle => 'New Event';

  @override
  String get eventTypeLabel => 'Event Type';

  @override
  String get detailsSection => 'Details';

  @override
  String get locationSection => 'Location (Optional)';

  @override
  String get eventTitleLabel => 'Title *';

  @override
  String get eventDateLabel => 'Date *';

  @override
  String get eventTimeLabel => 'Time (Optional)';

  @override
  String get eventLocationLabel => 'Address or Venue Name';

  @override
  String get eventMapsUrlLabel => 'Google Maps Link';

  @override
  String get eventTitleError => 'Title is required';

  @override
  String get eventCreatedMessage => 'Event created successfully';

  @override
  String get eventCreationError => 'Error creating event';

  @override
  String get eventNotificationInfo =>
      'All members will receive a notification for this event.';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search member by name...';

  @override
  String get familyStatsTitle => 'Family Statistics';

  @override
  String get totalStat => 'Total';

  @override
  String get menStat => 'Men';

  @override
  String get womenStat => 'Women';

  @override
  String get aliveStat => 'Alive';

  @override
  String get deceasedStat => 'Deceased';

  @override
  String get allMembersTitle => 'All Members';

  @override
  String get noSearchResults => 'No results found';

  @override
  String get searchRetry => 'Try with another name';

  @override
  String get eventsTitle => 'Events';

  @override
  String get newEventButton => 'New Event';

  @override
  String get noEvents => 'No events';

  @override
  String get noEventsSubtitle => 'Family events will appear here';

  @override
  String get todaySection => 'Today';

  @override
  String get upcomingSection => 'Upcoming';

  @override
  String get pastSection => 'Past';

  @override
  String get timeLabel => 'Time';

  @override
  String get locationLabel => 'Location';

  @override
  String get openMapButton => 'Open in Google Maps';

  @override
  String get familyTreeTitle => 'Family Tree';

  @override
  String get noTreeSelected => 'No tree selected';

  @override
  String get resetTooltip => 'Reset';

  @override
  String get addMemberButton => 'Add';

  @override
  String get noMembersInTree => 'No members in tree';

  @override
  String get addFirstMember => 'Start by adding the first family member.';

  @override
  String get noMembersAdmin =>
      'The administrator has not added any members yet.';

  @override
  String get addFirstMemberButton => 'Add First Member';

  @override
  String get treeInstructions => 'Pinch to zoom • Drag to pan';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get infoTitle => 'Information';

  @override
  String get birthDateLabel => 'Date of Birth';

  @override
  String get birthPlaceLabel => 'Place of Birth';

  @override
  String get genderLabel => 'Gender';

  @override
  String get siblingRankLabel => 'Sibling Rank';

  @override
  String get ageLabel => 'Age';

  @override
  String get yearsSuffix => 'years';

  @override
  String get deathDateLabel => 'Date of Death';

  @override
  String get familyRelationsTitle => 'Family Relations';

  @override
  String get fatherLabel => 'Father';

  @override
  String get motherLabel => 'Mother';

  @override
  String get wifeLabel => 'Wife';

  @override
  String get husbandLabel => 'Husband';

  @override
  String get childrenLabel => 'Children';

  @override
  String get sonLabel => 'Son';

  @override
  String get daughterLabel => 'Daughter';

  @override
  String get noRelations => 'No family relations recorded';

  @override
  String get notesTitle => 'Notes';

  @override
  String get treeUpdated => 'Tree updated';

  @override
  String get treeCreated => 'Tree created successfully';

  @override
  String get eventTypeWedding => 'Wedding';

  @override
  String get eventTypeBirth => 'Birth';

  @override
  String get eventTypeDeath => 'Death';

  @override
  String get eventTypeReunion => 'Family Reunion';

  @override
  String get eventTypeReligious => 'Religious Holiday';

  @override
  String get eventTypeOther => 'Other';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusPending => 'Pending';

  @override
  String get linkedMemberTitle => 'My Tree Profile';

  @override
  String get viewFullProfile => 'View Full Profile';

  @override
  String get permissionsTitle => 'My Permissions';

  @override
  String get permissionViewTree => 'View Tree';

  @override
  String get permissionEditMembers => 'Edit Members';

  @override
  String get permissionCreateEvents => 'Create Events';

  @override
  String get permissionManageUsers => 'Manage Users';

  @override
  String get logoutAction => 'Logout';

  @override
  String get promotedToAdmin => 'You are now Admin!';

  @override
  String get notProvided => 'Not provided';

  @override
  String get eventTitleHint => 'Ex: Wedding of Ahmed and Fatima';

  @override
  String get eventLocationHint => 'Ex: Party Hall, Casablanca';

  @override
  String get eventDescriptionHint => 'Additional information...';

  @override
  String get eventCreatedSuccess => 'Event created successfully';

  @override
  String get eventCreationErrorDefault => 'Error creating event';

  @override
  String get success => 'Operation successful';
}
