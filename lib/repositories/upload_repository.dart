import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadRepository {
  final Dio _dio = Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String cloudName = 'dwuwvfaw6';
  final String uploadPreset = 'flutter_unsigned';

  // Pick audio file
  Future<File?> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }

    return null;
  }

  // Upload file to Cloudinary and return URL
  Future<String> uploadToCloudinary(File file) async {
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/audio/upload';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
    });

    final response = await _dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return response.data['secure_url'];
    } else {
      throw Exception('Cloudinary upload failed');
    }
  }

  // Save metadata to Firestore
  Future<void> saveMetadata({
    required String audioUrl,
    required String title,
    required String artist,
    String? description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final data = {
      'audioUrl': audioUrl,
      'title': title,
      'artist': artist,
      'description': description ?? '',
      'uploadedBy': user.uid,
      'uploadedAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('audio_tracks').add(data);
  }
}
