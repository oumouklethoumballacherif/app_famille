// Configuration constants for the Family Tree application

class AppConstants {
  // App Info
  static const String appName = 'Arbre Familial';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String treesCollection = 'trees';
  static const String membersCollection = 'members';
  static const String eventsCollection = 'events';

  // Storage Paths
  static const String profilePhotosPath = 'profile_photos';

  // Default Values
  static const String defaultMalePhotoUrl = 'assets/images/default_male.png';
  static const String defaultFemalePhotoUrl =
      'assets/images/default_female.png';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Pagination
  static const int defaultPageSize = 20;
}
