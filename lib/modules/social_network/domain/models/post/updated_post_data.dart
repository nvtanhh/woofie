import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

class EditedPostData {
  Post originPost;
  String? newContent;
  List<Media>? deletedMedias;
  List<MediaFile>? newAddedFiles;
  List<Pet>? taggedPets;
  Location? location;

  List<UploadedMedia>? newAddedMedias = [];

  EditedPostData({required this.originPost, this.newContent, this.deletedMedias, this.newAddedFiles, this.taggedPets, this.location});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'origin_post': originPost.toJson(),
        'new_content': newContent,
        'deleted_medias': deletedMedias?.map((e) => e.toJson()).toList(),
        'tagged_pets': taggedPets?.map((e) => e.toJson()).toList(),
        'location': location?.toJson(),
        'new_added_medias': newAddedMedias?.map((e) => e.toJson()).toList()
      };
}
