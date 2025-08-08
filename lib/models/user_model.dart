import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String displayName;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };
  }
}
