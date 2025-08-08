class Playlist {
  final String id;
  final String title;
  final String ownerId;
  final List<String> trackIds;
  final DateTime createdAt;

  Playlist({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.trackIds,
    required this.createdAt,
  });

  factory Playlist.fromMap(Map<String, dynamic> map, String documentId) {
    return Playlist(
      id: documentId,
      title: map['title'] ?? '',
      ownerId: map['ownerId'] ?? '',
      trackIds: List<String>.from(map['trackIds'] ?? []),
      createdAt: (map['createdAt']).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ownerId': ownerId,
      'trackIds': trackIds,
      'createdAt': createdAt,
    };
  }
}
