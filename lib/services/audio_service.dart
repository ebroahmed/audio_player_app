import 'package:cloud_firestore/cloud_firestore.dart';

class AudioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getAllAudios() {
    return _firestore
        .collection('audio_tracks')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
