import 'package:audio_player_app/models/user_model.dart';
import 'package:audio_player_app/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Provide instance of AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Stream provider of Firebase User auth state changes
final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges();
});

// Future provider to get AppUser from Firestore for current Firebase User
final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(firebaseAuthStateProvider).asData?.value;

  if (authState == null) {
    return null; // user not logged in
  }

  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getAppUser(authState.uid);
});
