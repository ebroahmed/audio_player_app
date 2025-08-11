import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/screens/upload_screen.dart';

import 'package:audio_player_app/widgets/free_audios_list_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'audio_player_screen.dart';

class LocalAudioFile {
  final String path;
  final String name;

  LocalAudioFile({required this.path, required this.name});
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<LocalAudioFile> _audioFiles = [];
  bool _isLocalFilesLoading = false;
  int _currentIndex = 0;

  Future<void> _pickAudioFiles() async {
    setState(() {
      _isLocalFilesLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    await Future.delayed(const Duration(seconds: 1)); // Simulate load delay

    if (result != null) {
      List<LocalAudioFile> files = result.files
          .map((file) => LocalAudioFile(path: file.path!, name: file.name))
          .toList();

      setState(() {
        _audioFiles = files;
      });
    }

    setState(() {
      _isLocalFilesLoading = false;
    });
  }

  String _shortPath(String fullPath) {
    if (fullPath.length <= 25) return fullPath;
    return '...${fullPath.substring(fullPath.length - 25)}';
  }

  void _authToUpload() {
    final userAsync = ref.read(currentUserProvider);
    userAsync.when(
      data: (user) {
        if (user == null) {
          // Not logged in, show login screen
          Navigator.of(context).pushNamed('/login');
        } else {
          // Logged in, go to upload screen
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => UploadScreen()));
        }
      },
      loading: () {},
      error: (err, stack) {},
    );
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
              image: const AssetImage('assets/images/track.png'),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _pickAudioFiles,
                icon: const Icon(Icons.library_music),
                label: const Text('Add audios from local storage.'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _authToUpload,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload your audios.'),
              ),
              const SizedBox(height: 16),

              // LOCAL AUDIOS SECTION
              Text(
                'Local Audios:',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                ),
              ),
              const SizedBox(height: 8),

              if (_isLocalFilesLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_audioFiles.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _audioFiles.length,
                  itemBuilder: (context, index) {
                    final file = _audioFiles[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixedVariant,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.audiotrack,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          file.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        subtitle: Text(
                          _shortPath(file.path),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
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
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'No local audios found.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),

              Divider(
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),

              // FREE AUDIOS SECTION
              Text(
                'Free Audios:',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                ),
              ),
              SizedBox(height: 400, child: const FreeAudiosListWidget()),
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
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          SalomonBottomBarItem(
            unselectedColor: Theme.of(
              context,
            ).colorScheme.onPrimaryFixedVariant,
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
