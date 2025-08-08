import 'package:cloud_firestore/cloud_firestore.dart';

class Track {
  final String id; // Firestore document ID
  final String title;
  final String artist;
  final String? album;
  final int durationMs;
  final String audioUrl; // Cloudinary URL
  final String cloudinaryPublicId;
  final String? artworkUrl;
  final String uploaderId; // Firebase Auth UID
  final List<String>? genre;
  final List<String>? tags;
  final DateTime createdAt;
  final int playCount;
  final int likeCount;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.durationMs,
    required this.audioUrl,
    required this.cloudinaryPublicId,
    this.artworkUrl,
    required this.uploaderId,
    this.genre,
    this.tags,
    required this.createdAt,
    this.playCount = 0,
    this.likeCount = 0,
  });

  /// From Firestore
  factory Track.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Track(
      id: doc.id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      album: data['album'],
      durationMs: data['durationMs'] ?? 0,
      audioUrl: data['audioUrl'] ?? '',
      cloudinaryPublicId: data['cloudinaryPublicId'] ?? '',
      artworkUrl: data['artworkUrl'],
      uploaderId: data['uploaderId'] ?? '',
      genre: (data['genre'] as List?)?.map((e) => e.toString()).toList(),
      tags: (data['tags'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      playCount: data['playCount'] ?? 0,
      likeCount: data['likeCount'] ?? 0,
    );
  }

  /// To Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'durationMs': durationMs,
      'audioUrl': audioUrl,
      'cloudinaryPublicId': cloudinaryPublicId,
      'artworkUrl': artworkUrl,
      'uploaderId': uploaderId,
      'genre': genre,
      'tags': tags,
      'createdAt': createdAt,
      'playCount': playCount,
      'likeCount': likeCount,
    };
  }
}
