import 'package:audio_player_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen for auth state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Get current Firebase User
  User? get currentUser => _auth.currentUser;

  // Sign up with email & password and create Firestore user document
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
    String? profileImageUrl,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;
    final appUser = AppUser(
      uid: user.uid,
      displayName: displayName,
      email: email,
      profileImageUrl: profileImageUrl,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(appUser.toMap());

    return appUser;
  }

  // Sign in with email & password
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      // User doc missing - create it with basic info
      final appUser = AppUser(
        uid: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? '',
        profileImageUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
      return appUser;
    }

    return AppUser.fromMap(userDoc.data()!, userDoc.id);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get app user data from Firestore by uid
  Future<AppUser?> getAppUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, uid);
    }
    return null;
  }
}
