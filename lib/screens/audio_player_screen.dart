import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/audio_player_provider.dart';
import 'package:audio_player_app/widgets/audio_player_controls.dart';

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title, style: GoogleFonts.quicksand()),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 30),
              // Animated Rotating Disk
              _AnimatedDisk(audioPath: audioPath, tag: title),
              const SizedBox(height: 25),
              // Track Info
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryFixedVariant,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artist,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Audio Controls
              AudioPlayerControls(audioPath: audioPath, title: title),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ...existing code...
}

class _AnimatedDisk extends ConsumerStatefulWidget {
  final String audioPath;
  final String tag;
  const _AnimatedDisk({required this.audioPath, required this.tag});

  @override
  ConsumerState<_AnimatedDisk> createState() => _AnimatedDiskState();
}

class _AnimatedDiskState extends ConsumerState<_AnimatedDisk>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    // Listen to player state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final player = ref.read(audioPlayerServiceProvider);
      player.playerStateStream.listen((state) {
        final playing = state.playing;
        if (playing && !_isPlaying) {
          _controller.repeat();
          setState(() => _isPlaying = true);
        } else if (!playing && _isPlaying) {
          _controller.stop();
          setState(() => _isPlaying = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: RotationTransition(
        turns: _controller,
        child: Container(
          height: 280,
          width: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,

            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 4,
            ),
            image: const DecorationImage(
              image: AssetImage("assets/images/track.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
