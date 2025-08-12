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
          return Center(
            child: Text(
              'No free audios found.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: audios.length,
          itemBuilder: (context, index) {
            final audio = audios[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.music_note,
                  color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                ),
                title: Text(
                  audio.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                  ),
                ),
                subtitle: Text(
                  audio.artist,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
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
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
          ),
        ),
      ),
    );
  }
}
