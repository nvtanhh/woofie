import 'dart:convert';
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

class UploadedMedia {
  final String uploadedUrl;
  final int type;

  UploadedMedia(this.uploadedUrl, this.type);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'url': uploadedUrl, 'type': type};

  String toJsonString() => json.encode(toJson());
}
