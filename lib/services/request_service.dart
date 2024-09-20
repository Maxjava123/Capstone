import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/request_model.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendRequest(String parentName, String accountId) async {
    await _firestore.collection('requests').add({
      'parentName': parentName,
      'childAccountId': accountId,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<RequestModel>> getRequestsByParent(String parentName) {
    return _firestore
        .collection('requests')
        .where('parentName', isEqualTo: parentName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RequestModel.fromDocument(doc))
            .toList());
  }
}
