import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

class EditedPostData {
  Post oldPost;
  String? content;
  List<Media>? deletedMedias;
  List<MediaFile>? newAddedFiles;
  List<Pet>? taggegPets;
  Location? location;

  List<MediaFileUploader> uploadedMediasToAddToPost = [];

  EditedPostData({required this.oldPost, this.content, this.deletedMedias, this.newAddedFiles, this.taggegPets, this.location});
}
