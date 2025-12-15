import 'package:firebase_messaging/firebase_messaging.dart';

/// Service for handling Firebase Cloud Messaging (Push Notifications)
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize notification service
  Future<void> initialize() async {
    // Request permission for iOS
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        // Save token to Firestore for the current user
        // This should be called when user logs in
        await _saveTokenToDatabase(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_saveTokenToDatabase);
    }

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  /// Save FCM token to database (to be implemented with user context)
  Future<void> _saveTokenToDatabase(String token) async {
    // TODO: Save token to user's document in Firestore
    // This requires the current user ID
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification or update UI
    final notification = message.notification;
    if (notification != null) {
      // You can show a local notification here using flutter_local_notifications
    }
  }

  /// Handle when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    // Navigate to appropriate screen based on message data
    final data = message.data;
    if (data.containsKey('eventId')) {
      // Navigate to event detail screen
      // This requires navigation context
    }
  }

  /// Get the FCM token for the current device
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to a topic (e.g., 'family_events')
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Subscribe to family events topic
  Future<void> subscribeToFamilyEvents() async {
    await subscribeToTopic('family_events');
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  // Note: You cannot access UI or navigation here
}
