import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Upload successful!')));

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
      appBar: AppBar(title: const Text('Upload Audio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.audiotrack),
              label: Text(
                selectedFile == null ? 'Pick Audio File' : 'Change Audio File',
              ),
            ),
            if (selectedFile != null)
              Text('Selected: ${selectedFile.path.split('/').last}'),

            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter title' : null,
                    onChanged: (val) => title = val.trim(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Artist'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Enter artist' : null,
                    onChanged: (val) => artist = val.trim(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                    ),
                    onChanged: (val) => description = val.trim(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),

            ElevatedButton(
              onPressed: isUploading ? null : _upload,
              child: isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
