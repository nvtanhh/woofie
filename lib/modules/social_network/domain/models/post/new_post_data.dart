import 'dart:io';

import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:uuid/uuid.dart';

class NewPostData {
  String content;
  List<MediaFile>? mediaFiles;
  PostType type;
  Location? location;
  List<Pet>? taggegPets;
  // State persistence variables
  Post? createdDraftPost;
  late PostStatus createdDraftPostStatus;
  late List<MediaFile> remainingMediaToCompress;
  List<MediaFile> compressedMedia = [];
  List<UploadedMedia> uploadedMediasToAddToPost = [];
  bool postPublishRequested = false;
  File? mediaThumbnail;

  late String newPostUuid;
  // late String _cachedKey;

  NewPostData({required this.content, required this.type, this.mediaFiles, this.taggegPets, this.location}) {
    remainingMediaToCompress = mediaFiles ?? [];
    newPostUuid = const Uuid().v4();
  }

  bool hasMedia() {
    return mediaFiles != null && mediaFiles!.isNotEmpty;
  }

  List<MediaFile> getMedia() {
    return hasMedia() ? mediaFiles! : [];
  }

  // String getUniqueKey() {
  //   if (_cachedKey != null) return _cachedKey;

  //   String key = '';
  //   if (text != null) key += text;
  //   if (hasMedia()) {
  //     media.forEach((File mediaItem) {
  //       key += mediaItem.path;
  //     });
  //   }

  //   var bytes = utf8.encode(key);
  //   var digest = sha256.convert(bytes);

  //   _cachedKey = digest.toString();

  //   return _cachedKey;
  // }
}

enum PostUploaderStatus {
  idle,
  creatingPost,
  compressingPostMedia,
  addingPostMedia,
  publishing,
  processing,
  success,
  failed,
  cancelling,
  cancelled,
}
