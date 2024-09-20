import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final DateTime startTime;
  final DateTime endTime;
  final String teacherId;
  final List<String> studentIds;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.startTime,
    required this.endTime,
    required this.teacherId,
    required this.studentIds,
  });

  factory EventModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      eventId: doc.id,
      eventName: data['eventName'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      teacherId: data['teacherId'],
      studentIds: List<String>.from(data['studentIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'startTime': startTime,
      'endTime': endTime,
      'teacherId': teacherId,
      'studentIds': studentIds,
    };
  }
}
