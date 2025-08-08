import 'package:audio_player_app/services/audio_player_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});
