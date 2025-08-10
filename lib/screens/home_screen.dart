import 'package:audio_player_app/screens/upload_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'audio_player_screen.dart'; // Your existing modern audio player screen

class LocalAudioFile {
  final String path;
  final String name;

  LocalAudioFile({required this.path, required this.name});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LocalAudioFile> _audioFiles = [];
  bool _loading = false;

  Future<void> _pickAudioFiles() async {
    setState(() {
      _loading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        List<LocalAudioFile> files = result.files
            .map((file) => LocalAudioFile(path: file.path!, name: file.name))
            .toList();

        setState(() {
          _audioFiles = files;
        });
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick audio files: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Optionally, you can call _pickAudioFiles() here to prompt immediately
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Audio List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music),
            tooltip: 'Pick audio files',
            onPressed: _pickAudioFiles,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => UploadScreen()));
            },
            child: Text('Upload'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _audioFiles.isEmpty
          ? Center(
              child: Text(
                'No audio files loaded.\nTap the music icon to pick files.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: _audioFiles.length,
              itemBuilder: (context, index) {
                final file = _audioFiles[index];
                return ListTile(
                  leading: const Icon(Icons.audiotrack, size: 40),
                  title: Text(file.name),
                  subtitle: Text(file.path),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AudioPlayerScreen(
                          title: file.name,
                          artist: 'Local File',
                          description: '',
                          audioPath: file.path,
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
