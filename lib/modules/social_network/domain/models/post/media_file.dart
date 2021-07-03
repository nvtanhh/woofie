import 'dart:io';

import 'package:file_picker/file_picker.dart';

class MediaFile {
  File file;
  final FileType? type;

  MediaFile(this.file, this.type);

  bool get isImage => type == FileType.image;
  bool get isVideo => type == FileType.video;

  void delete() {
    if (file.existsSync()) file.delete();
  }
}

class MediaFileUploader {
  final String uploadedUrl;
  final int type;

  MediaFileUploader(this.uploadedUrl, this.type);
}
