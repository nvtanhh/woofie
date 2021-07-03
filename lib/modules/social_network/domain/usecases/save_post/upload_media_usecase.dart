import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';

@lazySingleton
class UploadMediaUsecase {
  final SavePostRepository _savePostRepository;

  UploadMediaUsecase(this._savePostRepository);

  Future<String?> call(String url, File file) async {
    return _savePostRepository.putObjectByPresignedUrl(url, file);
  }
}
