import 'package:audio_player_app/screens/upload_screen.dart';
import 'package:audio_player_app/widgets/free_audios_list_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'audio_player_screen.dart';

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

  Future<void> _pickAudioFiles() async {
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
  }

  String _shortPath(String fullPath) {
    if (fullPath.length <= 25) return fullPath;
    return '...${fullPath.substring(fullPath.length - 25)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: _pickAudioFiles,
            icon: const Icon(Icons.library_music),
            label: const Text('Add audios from local storage.'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => UploadScreen()));
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload your audios.'),
          ),
          const SizedBox(height: 16),
          if (_audioFiles.isNotEmpty) ...[
            const Text(
              'Local Audios:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _audioFiles.length,
              itemBuilder: (context, index) {
                final file = _audioFiles[index];
                return ListTile(
                  leading: const Icon(Icons.audiotrack, size: 40),
                  title: Text(file.name),
                  subtitle: Text(_shortPath(file.path)),
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
            const Divider(),
          ],
          const Text(
            'Free Audios:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 400, // Adjust as needed
            child: FreeAudiosListWidget(),
          ),
        ],
      ),
    );
  }
}
