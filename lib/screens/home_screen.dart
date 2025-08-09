import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/screens/audio_list_screen.dart';
import 'package:audio_player_app/widgets/auth_required_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
            label: const Text('Logout'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AudioListScreen()),
              );
            },
            child: const Text("View Uploaded Audios"),
          ),
        ],
        title: const Text('Audio Player'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Upload Audio'),
          onPressed: () {
            userAsyncValue.when(
              data: (user) {
                if (user == null) {
                  // Show login prompt dialog
                  showDialog(
                    context: context,
                    builder: (context) => AuthRequiredDialog(
                      onLoginTap: () {
                        Navigator.of(context).pop(); // close dialog
                        Navigator.of(context).pushNamed('/login');
                      },
                    ),
                  );
                } else {
                  // User logged in, go to upload screen
                  Navigator.of(context).pushNamed('/upload');
                }
              },
              loading: () => null, // or show loading indicator
              error: (err, stack) => null,
            );
          },
        ),
      ),
    );
  }
}
