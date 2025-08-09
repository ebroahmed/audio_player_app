import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'audio_player_screen.dart'; // Your modern audio player screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadSongs();
  }

  Future<void> _requestPermissionAndLoadSongs() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        // Permission denied, show a message and return
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Storage permission is required to load local audios.",
            ),
          ),
        );
        return;
      }
    }

    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    setState(() {
      _songs = songs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Audio List')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _songs.isEmpty
          ? const Center(child: Text('No audio files found on this device.'))
          : ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final localSong = _songs[index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: localSong.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.music_note, size: 40),
                  ),
                  title: Text(localSong.title),
                  subtitle: Text(localSong.artist ?? 'Unknown Artist'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AudioPlayerScreen(
                          title: localSong.title,
                          artist: localSong.artist ?? 'Unknown Artist',
                          description:
                              '', // no description for local files, you can customize
                          audioPath: '',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
