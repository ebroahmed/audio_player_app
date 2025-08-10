import 'package:audio_player_app/models/free_audios_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FreeAudiosRepository {
  final CollectionReference freeAudiosRef = FirebaseFirestore.instance
      .collection('free_audios');

  Future<List<FreeAudios>> fetchFreeAudios() async {
    final snapshot = await freeAudiosRef.get();
    return snapshot.docs.map((doc) {
      return FreeAudios.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> addFreeAudio(FreeAudios freeAudio) async {
    await freeAudiosRef.add(freeAudio.toMap());
  }

  Future<void> deleteFreeAudio(String id) async {
    await freeAudiosRef.doc(id).delete();
  }

  Future<void> updateFreeAudio(FreeAudios freeAudio) async {
    await freeAudiosRef.doc(freeAudio.id).update(freeAudio.toMap());
  }
}
