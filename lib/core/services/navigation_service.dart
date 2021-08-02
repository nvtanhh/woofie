import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/app/pages/chat_dashboard.dart';
import 'package:meowoof/modules/chat/app/pages/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class NavigationService {
  void navigateToPostDetail(Post post) {
    Get.to(
      () => PostDetail(
        post: post,
      ),
    );
  }

  void navigateToFunctionalPostDetail(Post post) {
    Get.to(() => AdoptionPetDetailWidget(post: post));
  }

  Future<NewPostData?> navigateToCreatePost() async {
    final newPost = await Get.to(
      () => const CreatePost(),
    ) as NewPostData?;
    return newPost;
  }

  Future<EditedPostData?> navigateToEditPost(Post post) async {
    final editedPostData = await Get.to(
      () => CreatePost(post: post),
    ) as EditedPostData?;
    return editedPostData;
  }

  Future navigateToChatDashboard() async {
    return Get.to(() => const ChatDashboard());
  }

  Future<bool?> navigateToChatRoom(
      {ChatRoom? room,
      User? user,
      Function(List<Message>)? onAddNewMessages}) async {
    final isError = await Get.to(() => ChatRoomPage(
        room: room,
        partner: user,
        onAddNewMessages: onAddNewMessages)) as bool?;
    return isError;
  }
}
