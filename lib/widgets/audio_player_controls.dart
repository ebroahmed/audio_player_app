import 'package:audio_player_app/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerControls extends ConsumerWidget {
  final String audioUrl;
  final String title;

  const AudioPlayerControls({
    super.key,
    required this.audioUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerServiceProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing ?? false;

            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return const CircularProgressIndicator();
            } else if (playing) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 48,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 48,
                onPressed: () async {
                  await player.setUrl(audioUrl);
                  player.play();
                },
              );
            }
          },
        ),
      ],
    );
  }
}
