import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

class EditedPostData {
  Post originPost;
  String? newContent;
  List<Pet>? newTaggedPets;
  List<Pet>? deletedTaggedPets;
  List<MediaFile>? newAddedFiles;
  List<Media>? deletedMedias;
  Location? location;

  List<UploadedMedia>? newAddedMedias = [];

  EditedPostData({
    required this.originPost,
    this.newContent,
    this.deletedMedias,
    this.newAddedFiles,
    this.newTaggedPets,
    this.deletedTaggedPets,
    this.location,
  });

  // Map<String, dynamic> toJsonForEdit() => <String, dynamic>{
  //       'origin_post_id': originPost.id,
  //       'new_content': newContent,
  //       'deleted_media_ids': deletedMedias?.map((e) => e.id).toList(),
  //       'tagged_pet_ids': newTaggedPets?.map((e) => e.id).toList(),
  //       'location': location?.toJson(),
  //       'new_added_medias': newAddedMedias?.map((e) => e.toJson()).toList()
  //     };

  List<int> get deletedMediaIds => deletedMedias?.map((e) => e.id).toList() ?? [];
  List<int> get newTaggedPetIds => newTaggedPets?.map((e) => e.id).toList() ?? [];
  List<int> get deletedTaggedPetIds => deletedTaggedPets?.map((e) => e.id).toList() ?? [];
  // List<Map> get newAddedMediasToJson =>
  //     newAddedMedias?.map((e) => e.toJson()).toList() ?? [];
}
