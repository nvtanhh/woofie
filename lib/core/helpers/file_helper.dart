import 'dart:io';

import 'package:mime/mime.dart';

class FileHelper {
  static Future<String> getFileMimeType(File file) async {
    String? mimeType = lookupMimeType(file.path);

    mimeType ??= await _getFileMimeTypeFromMagicHeaders(file);

    return mimeType ?? 'application/octet-stream';
  }

  static Future<String?>? _getFileMimeTypeFromMagicHeaders(File file) async {
    // TODO When file uploads become larger, this needs to be turned into a stream
    final List<int> fileBytes = file.readAsBytesSync();

    int magicHeaderBytesLeft = 12;
    final List<int> magicHeaders = [];

    for (final fileByte in fileBytes) {
      if (magicHeaderBytesLeft == 0) break;
      magicHeaders.add(fileByte);
      magicHeaderBytesLeft--;
    }
    return lookupMimeType(file.path, headerBytes: magicHeaders);
  }
}
