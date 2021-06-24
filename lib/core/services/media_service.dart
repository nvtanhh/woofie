import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/file_helper.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

@lazySingleton
class MediaService {
  String defaultThumbnailCacheUrl = '/thumbnailCache';

  Future<Uint8List?> getVideoThumbnailFromFile(File videoFile) async {
    return VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 80.w.toInt(),
      quality: 100,
    );
  }

  Future<String?> getVideoThumbnailFromUrl(String url) async {
    final filePath = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path + defaultThumbnailCacheUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 80.h.toInt(),
      quality: 100,
    );
    return filePath;
  }

  void clearAllThumbnail() {}

  Future<File?> cropImage(File image, {double? ratioX, double? ratioY}) async {
    return ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: ratioX != null && ratioY != null ? CropAspectRatio(ratioX: ratioX, ratioY: ratioY) : null,
      androidUiSettings: const AndroidUiSettings(
        toolbarColor: Colors.black,
        statusBarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
      ),
    );
  }

  Future<FileType?> getMediaType(File file) async {
    final String mediaMime = await FileHelper.getFileMimeType(file);

    final String mediaMimeType = mediaMime.split('/')[0];

    if (mediaMimeType == 'video') {
      return FileType.video;
    } else if (mediaMimeType == 'image') {
      return FileType.image;
    } else if (mediaMimeType == 'audio') {
      return FileType.audio;
    } else {
      return null;
    }
  }

  Future<MediaFile> convertToMediaFile(File file) async {
    final FileType? type = await getMediaType(file);
    return MediaFile(file, type);
  }
}
