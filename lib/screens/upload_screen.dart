import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/upload_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String artist = '';
  String description = '';
  String? errorMessage;

  Future<void> _pickFile() async {
    final file = await ref.read(uploadRepositoryProvider).pickAudioFile();
    if (file != null) {
      ref.read(selectedFileProvider.notifier).state = file;
    }
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate()) return;

    final file = ref.read(selectedFileProvider);
    if (file == null) {
      setState(() {
        errorMessage = 'Please select an audio file';
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    try {
      ref.read(uploadStateProvider.notifier).state = true;

      final uploadRepo = ref.read(uploadRepositoryProvider);
      final url = await uploadRepo.uploadToCloudinary(file);

      await uploadRepo.saveMetadata(
        audioUrl: url,
        title: title,
        artist: artist,
        description: description,
      );

      ref.read(selectedFileProvider.notifier).state = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text('Upload successful!'),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      ref.read(uploadStateProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedFile = ref.watch(selectedFileProvider);
    final isUploading = ref.watch(uploadStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Upload Audio', style: GoogleFonts.quicksand(fontSize: 20)),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Image(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              image: const AssetImage('assets/images/track.png'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: ListView(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _pickFile,
                  icon: const Icon(Icons.audiotrack),
                  label: Text(
                    selectedFile == null
                        ? 'Pick Audio File'
                        : 'Change Audio File',
                  ),
                ),
                if (selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Selected: ${selectedFile.path.split('/').last}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixedVariant,
                          decorationThickness: 0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryFixedVariant,
                          ),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter title' : null,
                        onChanged: (val) => title = val.trim(),
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixedVariant,
                          decorationThickness: 0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Artist',
                          labelStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryFixedVariant,
                          ),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter artist' : null,
                        onChanged: (val) => artist = val.trim(),
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixedVariant,
                          decorationThickness: 0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          labelStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryFixedVariant,
                          ),
                        ),
                        onChanged: (val) => description = val.trim(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                Align(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: isUploading ? null : _upload,
                    child: isUploading
                        ? CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
