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

  Future<Uint8List?> getVideoThumbnailFromFile(File videoFile,
      {double? maxWidth, bool isConstraintsSize = true, int? quality}) async {
    return VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: isConstraintsSize ? maxWidth?.toInt() ?? 80.w.toInt() : 0,
      quality: quality ?? 100,
    );
  }

  Future<String?> getVideoThumbnailFromUrl(String url,
      {double? maxWidth, bool isConstraintsSize = true, int? quality}) async {
    final filePath = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: await _getThumbnailCachePath(defaultThumbnailCacheUrl),
      imageFormat: ImageFormat.JPEG,
      maxWidth: isConstraintsSize ? maxWidth?.toInt() ?? 80.w.toInt() : 0,
      quality: quality ?? 100,
    );
    return filePath;
  }

  void clearAllThumbnail() {}

  Future<File?> cropImage(File image, {double? ratioX, double? ratioY}) async {
    return ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: ratioX != null && ratioY != null
          ? CropAspectRatio(ratioX: ratioX, ratioY: ratioY)
          : null,
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
    final Uint8List? compressedImageData =
        await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 80,
    );
    if (compressedImageData != null) {
      printInfo(
          info:
              'Compressed image from ${image.lengthSync()} ===> ${compressedImageData.length}');
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

    final int exitCode = await _flutterFFmpeg.execute(
        '-i ${video.path} -filter:v scale=720:-2 -vcodec libx264 -crf 23 -preset veryfast ${resultFilePath}');

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
    Directory mediaCacheDir =
        Directory(join(applicationsDocumentsDir.path, 'mediaCache'));

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

  Future<List<MediaFile>> pickMedias(
      {bool allowMultiple = true, FileType type = FileType.media}) async {
    final List<MediaFile> medias = [];
    List<File>? files;
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: allowMultiple, type: type);
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
    if (files != null) {
      await Future.wait(files.map((file) async {
        final MediaFile media = await convertToMediaFile(file);
        medias.add(media);
      }));
    }
    return medias;
  }

  Future<MediaFile> compressPostMediaItem(MediaFile postMediaItem) async {
    if (postMediaItem.isImage) {
      postMediaItem.file = await compressImage(postMediaItem.file);
    } else if (postMediaItem.isVideo) {
      postMediaItem.file = await compressVideo(postMediaItem.file);
    } else {
      printError(info: 'Unsupported media type for compression');
    }
    return postMediaItem;
  }

  Future<String> _getThumbnailCachePath(String dir) async {
    final String path =
        (await getTemporaryDirectory()).path + defaultThumbnailCacheUrl;
    final dir = Directory(path);
    if (!(await dir.exists())) {
      await dir.create();
    }
    return path;
  }
}
