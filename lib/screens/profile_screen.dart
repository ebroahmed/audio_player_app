import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/screens/audio_player_screen.dart';
import 'package:audio_player_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logged Out!'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => true);
              }
            },
          ),
        ],
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
          userAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (user) {
              if (user == null) {
                return Center(
                  child: Stack(
                    children: [
                      Text(
                        'Not logged in yet.',
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixedVariant,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          label: Text(
                            'Click To Login.',
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryFixedVariant,
                            ),
                          ),
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final firstLetter = user.displayName.isNotEmpty
                  ? user.displayName[0].toUpperCase()
                  : '?';

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display Name
                  Center(
                    child: Text(
                      user.displayName,
                      style: GoogleFonts.quicksand(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryFixedVariant,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Center(
                    child: Text(
                      user.email,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(
                    color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your Uploaded Audios',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryFixedVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User's uploaded audios from Firestore
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('audio_tracks')
                        .where('uploadedBy', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text('No uploads yet.')),
                        );
                      }
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,

                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryFixedVariant,
                              ),
                              title: Text(
                                data['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryFixedVariant,
                                ),
                              ),
                              subtitle: Text(
                                data['artist'] ?? '',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioPlayerScreen(
                                      title: data['title'] ?? 'No Title',
                                      artist: data['artist'] ?? '',
                                      description: data['description'] ?? '',
                                      audioPath: data['audioUrl'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        },
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
