import 'dart:async';
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/database_service.dart';

/// Provider for managing events state
class EventProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<FamilyEvent> _events = [];
  List<FamilyEvent> _upcomingEvents = [];
  FamilyEvent? _selectedEvent;
  bool _isLoading = true;
  String? _error;
  StreamSubscription<List<FamilyEvent>>? _eventsSubscription;

  EventProvider() {
    _init();
  }

  // Getters
  List<FamilyEvent> get events => _events;
  List<FamilyEvent> get upcomingEvents => _upcomingEvents;
  FamilyEvent? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get events for a specific month
  List<FamilyEvent> getEventsForMonth(DateTime month) {
    return _events
        .where((e) => e.date.year == month.year && e.date.month == month.month)
        .toList();
  }

  /// Get today's events
  List<FamilyEvent> get todayEvents {
    final now = DateTime.now();
    return _events
        .where((e) =>
            e.date.year == now.year &&
            e.date.month == now.month &&
            e.date.day == now.day)
        .toList();
  }

  /// Initialize events stream
  void _init() {
    _eventsSubscription = _databaseService.eventsStream().listen(
      (events) {
        _events = events;
        _updateUpcomingEvents();
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Update upcoming events list
  void _updateUpcomingEvents() {
    final now = DateTime.now();
    _upcomingEvents =
        _events.where((e) => e.date.isAfter(now)).take(5).toList();
  }

  /// Select an event for detailed view
  void selectEvent(FamilyEvent? event) {
    _selectedEvent = event;
    notifyListeners();
  }

  /// Add a new event
  Future<String?> addEvent(FamilyEvent event) async {
    try {
      _error = null;
      final id = await _databaseService.addEvent(event);
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Update an event
  Future<bool> updateEvent(FamilyEvent event) async {
    try {
      _error = null;
      await _databaseService.updateEvent(event);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete an event
  Future<bool> deleteEvent(String eventId) async {
    try {
      _error = null;
      await _databaseService.deleteEvent(eventId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get events by type
  List<FamilyEvent> getEventsByType(EventType type) {
    return _events.where((e) => e.type == type).toList();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }
}
