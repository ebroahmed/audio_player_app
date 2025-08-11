import 'package:audio_player_app/screens/upload_screen.dart';
import 'package:audio_player_app/widgets/free_audios_list_widget.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
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
  int _currentIndex = 0;

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Audio Player'),
      ),
      body: Stack(
        children: [
          Center(
            child: Image(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              image: AssetImage('assets/images/track.png'),
            ),
          ),
          ListView(
            padding: EdgeInsets.all(16),
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _pickAudioFiles,
                icon: Icon(Icons.library_music),
                label: Text('Add audios from local storage.'),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
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
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
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
                      ),
                    );
                  },
                ),
                Divider(),
              ],
              Text(
                'Free Audios:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
              SizedBox(
                height: 400, // Adjust as needed
                child: FreeAudiosListWidget(),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          SalomonBottomBarItem(
            unselectedColor: Theme.of(
              context,
            ).colorScheme.onPrimaryFixedVariant,
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),

          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
