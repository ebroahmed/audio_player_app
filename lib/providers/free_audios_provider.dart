import 'package:audio_player_app/models/free_audios_model.dart';
import 'package:audio_player_app/repositories/free_audios_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final freeAudiosRepositoryProvider = Provider<FreeAudiosRepository>((ref) {
  return FreeAudiosRepository();
});

final freeAudiosListProvider = FutureProvider<List<FreeAudios>>((ref) async {
  final repo = ref.watch(freeAudiosRepositoryProvider);
  return repo.fetchFreeAudios();
});
