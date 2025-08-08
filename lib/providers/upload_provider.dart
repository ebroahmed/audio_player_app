import 'dart:io';

import 'package:audio_player_app/repositories/upload_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository();
});

final uploadStateProvider = StateProvider<bool>((ref) => false);

final selectedFileProvider = StateProvider<File?>((ref) => null);
