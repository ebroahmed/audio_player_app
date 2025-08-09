import 'package:audio_player_app/widgets/audio_player_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerScreen extends ConsumerWidget {
  final String title;
  final String artist;
  final String description;
  final String audioPath;

  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.description,
    required this.audioPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E2C), Color(0xFF2A2A40)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30),

                // Artwork / Placeholder
                Hero(
                  tag: title, // match from list page
                  child: Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/placeholder_music.jpg",
                        ), // or dynamic
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 25,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Track Info
                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      artist,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Progress slider placeholder (can link with player later)
                Column(
                  children: [
                    Slider(
                      value: 0,
                      min: 0,
                      max: 100,
                      activeColor: Colors.redAccent,
                      inactiveColor: Colors.white.withOpacity(0.3),
                      onChanged: (_) {},
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("0:00", style: TextStyle(color: Colors.white)),
                          Text("3:45", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Audio Controls
                AudioPlayerControls(audioPath: audioPath, title: title),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
