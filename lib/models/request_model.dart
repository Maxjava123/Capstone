import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String parentName;
  final String childAccountId;
  final String status;
  final DateTime timestamp;

  RequestModel({
    required this.parentName,
    required this.childAccountId,
    required this.status,
    required this.timestamp,
  });

  factory RequestModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RequestModel(
      parentName: data['parentName'],
      childAccountId: data['childAccountId'],
      status: data['status'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
