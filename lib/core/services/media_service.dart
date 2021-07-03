import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/file_helper.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:get/get.dart';

@lazySingleton
class MediaService {
  String defaultThumbnailCacheUrl = '/thumbnailCache';
  Map _thumbnail_cache = {};
  static const Uuid _uuid = Uuid();

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

  Future<File> compressImage(File image) async {
    File resultFile;
    final Uint8List? compressedImageData = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 80,
    );
    if (compressedImageData != null) {
      printInfo(info: 'Compressed image from ${image.lengthSync()} ===> ${compressedImageData.length}');
      final String imageName = basename(image.path);
      final tempPath = await _getTempPath();
      final String thumbnailPath = '$tempPath/$imageName';
      final file = File(thumbnailPath);
      file.writeAsBytesSync(List.from(compressedImageData));
      resultFile = file;
    } else {
      debugPrint('Failed to compress image, using original file');
      resultFile = image;
    }
    return resultFile;
  }

  Future<File> compressVideo(File video) async {
    File resultFile;

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    final String videoName = basename(video.path);
    final path = await _getTempPath();
    final String resultFilePath = '$path/$videoName';

    final int exitCode =
        await _flutterFFmpeg.execute('-i ${video.path} -filter:v scale=720:-2 -vcodec libx264 -crf 23 -preset veryfast ${resultFilePath}');

    if (exitCode == 0) {
      resultFile = File(resultFilePath);
    } else {
      debugPrint('Failed to compress video, using original file');
      resultFile = video;
    }

    return resultFile;
  }

  Future<String> _getTempPath() async {
    final Directory applicationsDocumentsDir = await getTemporaryDirectory();
    Directory mediaCacheDir = Directory(join(applicationsDocumentsDir.path, 'mediaCache'));

    if (await mediaCacheDir.exists()) return mediaCacheDir.path;

    mediaCacheDir = await mediaCacheDir.create();

    return mediaCacheDir.path;
  }

  Future<File?> getVideoThumbnail(File videoFile) async {
    final Uint8List? thumbnailData = await getVideoThumbnailFromFile(videoFile);
    if (thumbnailData != null) {
      final String videoExtension = basename(videoFile.path);
      final String tmpImageName = 'thumbnail_${_uuid.v4()}_$videoExtension';
      final tempPath = await _getTempPath();
      final String thumbnailPath = '$tempPath/$tmpImageName';
      final file = File(thumbnailPath);
      _thumbnail_cache[videoFile.path] = file;
      file.writeAsBytesSync(thumbnailData);

      return file;
    } else {
      return null;
    }
  }
}
