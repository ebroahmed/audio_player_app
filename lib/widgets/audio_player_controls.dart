import 'package:audio_player_app/services/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/audio_player_provider.dart';

class AudioPlayerControls extends ConsumerStatefulWidget {
  final String audioPath; // renamed from audioUrl
  final String title;

  const AudioPlayerControls({
    super.key,
    required this.audioPath,
    required this.title,
  });

  @override
  ConsumerState<AudioPlayerControls> createState() =>
      _AudioPlayerControlsState();
}

class _AudioPlayerControlsState extends ConsumerState<AudioPlayerControls> {
  late final AudioPlayerService player;
  double playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    player = ref.read(audioPlayerServiceProvider);
    _init();
  }

  Future<void> _init() async {
    try {
      if (widget.audioPath.startsWith('http')) {
        await player.setUrl(widget.audioPath);
      } else {
        await player.setFilePath(widget.audioPath);
      }
      await player.setSpeed(playbackSpeed); // start at 1x speed
    } catch (e) {
      // handle error loading audio URL or local file
      debugPrint('Error loading audio: $e');
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "--:--";
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState =
                playerState?.processingState ?? ProcessingState.idle;
            final playing = playerState?.playing ?? false;

            return Column(
              children: [
                StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;

                    return StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, positionSnapshot) {
                        var position = positionSnapshot.data ?? Duration.zero;
                        if (position > duration) {
                          position = duration;
                        }

                        return Column(
                          children: [
                            Slider(
                              min: 0,
                              max: duration.inMilliseconds.toDouble(),
                              value: position.inMilliseconds.toDouble().clamp(
                                0,
                                duration.inMilliseconds.toDouble(),
                              ),
                              onChanged: (value) {
                                player.seek(
                                  Duration(milliseconds: value.toInt()),
                                );
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(position)),
                                  Text(_formatDuration(duration)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.stop),
                      iconSize: 36,
                      onPressed: processingState == ProcessingState.idle
                          ? null
                          : () => player.stop(),
                    ),

                    IconButton(
                      icon: playing
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      iconSize: 48,
                      onPressed:
                          processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering
                          ? null
                          : () {
                              if (playing) {
                                player.pause();
                              } else {
                                player.play();
                              }
                            },
                    ),

                    // Playback speed dropdown
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: DropdownButton<double>(
                        value: playbackSpeed,
                        items: const [
                          DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                          DropdownMenuItem(value: 1.0, child: Text("1x")),
                          DropdownMenuItem(value: 1.5, child: Text("1.5x")),
                          DropdownMenuItem(value: 2.0, child: Text("2x")),
                        ],
                        onChanged: (speed) {
                          if (speed == null) return;
                          setState(() {
                            playbackSpeed = speed;
                          });
                          player.setSpeed(speed);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
