import 'package:audio_player_app/providers/free_audios_provider.dart';
import 'package:audio_player_app/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FreeAudiosListWidget extends ConsumerWidget {
  const FreeAudiosListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeAudiosAsync = ref.watch(freeAudiosListProvider);

    return freeAudiosAsync.when(
      data: (audios) {
        if (audios.isEmpty) {
          return const Center(child: Text('No free audios found.'));
        }
        return ListView.builder(
          itemCount: audios.length,
          itemBuilder: (context, index) {
            final audio = audios[index];
            return ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(audio.title),
              subtitle: Text(audio.artist),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AudioPlayerScreen(
                      title: audio.title,
                      artist: audio.artist,
                      description: audio.description,
                      audioPath: audio.audioPath,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
