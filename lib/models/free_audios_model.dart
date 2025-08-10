class FreeAudios {
  final String id;
  final String title;
  final String artist;
  final String description;
  final String audioPath;

  FreeAudios({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.audioPath,
  });

  factory FreeAudios.fromMap(Map<String, dynamic> data, String documentId) {
    return FreeAudios(
      id: documentId,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      description: data['description'] ?? '',
      audioPath: data['audioPath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'description': description,
      'audioPath': audioPath,
    };
  }
}
