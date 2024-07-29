import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  String body;
  DateTime date;
  GeoPoint location;
  String? imageUrl;
  final String userId;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.userId,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ??
          GeoPoint(0, 0), // Default location if none provided
      imageUrl: data['imageUrl'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'date': Timestamp.fromDate(date), // Convert to Timestamp
      'location': location,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
