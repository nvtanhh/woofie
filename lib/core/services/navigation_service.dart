import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
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

  Future<Post?> navigateToSavePost({Post? post}) async {
    final newPost = await Get.to(
      () => CreatePost(
        post: post,
      ),
    ) as Post?;
    return newPost;
  }
}
