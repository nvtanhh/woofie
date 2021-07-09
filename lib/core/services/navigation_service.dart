import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class NavigationService {
  void navigateToPostDetail(Post post) {
    Get.to(
      () => PostDetail(
        post: post,
      ),
    );
  }

  Future<NewPostData?> navigateToCreatePost() async {
    final newPost = await Get.to(
      () => const CreatePost(),
    ) as NewPostData?;
    return newPost;
  }

  void navigateToEditPost(Post post, Function(String newContent, List<Media> deletedMedia, List<MediaFile> newAddedMedia) onEditPost) {
    Get.to(
      () => CreatePost(post: post, onEditPost: onEditPost),
    );
  }
}
