import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizer;
  final String eventType;
  final DateTime updatedAt;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.eventType,
    required this.updatedAt,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      organizer: map['organizer'] ?? '',
      eventType: map['eventType'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
