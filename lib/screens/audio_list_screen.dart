import 'package:audio_player_app/screens/audio_player_screen.dart';
import 'package:audio_player_app/services/audio_service.dart';
import 'package:flutter/material.dart';

class AudioListScreen extends StatelessWidget {
  final AudioService _audioService = AudioService();

  AudioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Audios")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _audioService.getAllAudios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No audios found"));
          }

          final audios = snapshot.data!;
          return ListView.builder(
            itemCount: audios.length,
            itemBuilder: (context, index) {
              final audio = audios[index];
              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(audio['title'] ?? 'No Title'),
                subtitle: Text(audio['artist'] ?? 'Unknown Artist'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AudioPlayerScreen(
                        title: audio['title'],
                        artist: audio['artist'],
                        description: audio['description'],
                        audioUrl: audio['audioUrl'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
