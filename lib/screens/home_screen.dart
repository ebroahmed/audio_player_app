import 'package:audio_player_app/widgets/audio_player_controls.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const exampleAudioUrl =
        'https://res.cloudinary.com/demo/video/upload/sample.mp3';

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Center(
        child: AudioPlayerControls(
          audioUrl: exampleAudioUrl,
          title: 'Sample Track',
        ),
      ),
    );
  }
}
