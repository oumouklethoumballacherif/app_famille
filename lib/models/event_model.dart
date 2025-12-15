import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Event types for family events
enum EventType {
  wedding,
  birth,
  death,
  reunion,
  religious,
  other,
}

/// Extension for EventType enum
extension EventTypeExtension on EventType {
  String get value {
    switch (this) {
      case EventType.wedding:
        return 'wedding';
      case EventType.birth:
        return 'birth';
      case EventType.death:
        return 'death';
      case EventType.reunion:
        return 'reunion';
      case EventType.religious:
        return 'religious';
      case EventType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case EventType.wedding:
        return 'Mariage';
      case EventType.birth:
        return 'Naissance';
      case EventType.death:
        return 'Décès';
      case EventType.reunion:
        return 'Réunion familiale';
      case EventType.religious:
        return 'Fête religieuse';
      case EventType.other:
        return 'Autre';
    }
  }

  String get displayNameAr {
    switch (this) {
      case EventType.wedding:
        return 'زواج';
      case EventType.birth:
        return 'ولادة';
      case EventType.death:
        return 'وفاة';
      case EventType.reunion:
        return 'لقاء عائلي';
      case EventType.religious:
        return 'مناسبة دينية';
      case EventType.other:
        return 'أخرى';
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.wedding:
        return Icons.favorite;
      case EventType.birth:
        return Icons.child_care;
      case EventType.death:
        return Icons.brightness_2;
      case EventType.reunion:
        return Icons.groups;
      case EventType.religious:
        return Icons.mosque;
      case EventType.other:
        return Icons.event;
    }
  }

  Color get color {
    switch (this) {
      case EventType.wedding:
        return Colors.pink;
      case EventType.birth:
        return Colors.green;
      case EventType.death:
        return Colors.grey;
      case EventType.reunion:
        return Colors.blue;
      case EventType.religious:
        return Colors.amber;
      case EventType.other:
        return Colors.purple;
    }
  }

  static EventType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'wedding':
        return EventType.wedding;
      case 'birth':
        return EventType.birth;
      case 'death':
        return EventType.death;
      case 'reunion':
        return EventType.reunion;
      case 'religious':
        return EventType.religious;
      default:
        return EventType.other;
    }
  }
}

/// Family event model
class FamilyEvent {
  final String id;
  final String title;
  final EventType type;
  final DateTime date;
  final TimeOfDay? time;
  final String? location;
  final String? locationUrl; // Google Maps URL
  final String? description;
  final List<String> relatedMemberIds; // Members involved in this event
  final String? imageUrl;
  final String createdBy; // User ID who created this event
  final DateTime createdAt;
  final bool isNotificationSent;

  FamilyEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    this.time,
    this.location,
    this.locationUrl,
    this.description,
    this.relatedMemberIds = const [],
    this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    this.isNotificationSent = false,
  });

  /// Check if the event is in the future
  bool get isUpcoming => date.isAfter(DateTime.now());

  /// Check if the event is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Create FamilyEvent from Firestore document
  factory FamilyEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    TimeOfDay? time;
    if (data['timeHour'] != null && data['timeMinute'] != null) {
      time = TimeOfDay(
        hour: data['timeHour'] as int,
        minute: data['timeMinute'] as int,
      );
    }

    return FamilyEvent(
      id: doc.id,
      title: data['title'] ?? '',
      type: EventTypeExtension.fromString(data['type'] ?? 'other'),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: time,
      location: data['location'],
      locationUrl: data['locationUrl'],
      description: data['description'],
      relatedMemberIds: List<String>.from(data['relatedMemberIds'] ?? []),
      imageUrl: data['imageUrl'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isNotificationSent: data['isNotificationSent'] ?? false,
    );
  }

  /// Convert FamilyEvent to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'type': type.value,
      'date': Timestamp.fromDate(date),
      'timeHour': time?.hour,
      'timeMinute': time?.minute,
      'location': location,
      'locationUrl': locationUrl,
      'description': description,
      'relatedMemberIds': relatedMemberIds,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'isNotificationSent': isNotificationSent,
    };
  }

  /// Create a copy with updated fields
  FamilyEvent copyWith({
    String? id,
    String? title,
    EventType? type,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    String? locationUrl,
    String? description,
    List<String>? relatedMemberIds,
    String? imageUrl,
    String? createdBy,
    DateTime? createdAt,
    bool? isNotificationSent,
  }) {
    return FamilyEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      locationUrl: locationUrl ?? this.locationUrl,
      description: description ?? this.description,
      relatedMemberIds: relatedMemberIds ?? this.relatedMemberIds,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isNotificationSent: isNotificationSent ?? this.isNotificationSent,
    );
  }
}
