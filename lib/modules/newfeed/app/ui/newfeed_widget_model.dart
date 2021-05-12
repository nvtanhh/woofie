import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/modules/newfeed/domain/usecases/get_posts_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
  final GetPostsUsecase _getPostsUsecase;
  final RxList<Post> _posts = RxList<Post>([]);

  NewFeedWidgetModel(this._getPostsUsecase);

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  void onCommentClick(int idPost) {
    Get.bottomSheet(
      CommentBottomSheetWidget(
        postId: idPost,
      ),
    );
  }

  void onLikeClick(int idPost) {}

  void getPosts() {
    call(() async => posts = await _getPostsUsecase.call());
  }

  List<Post> get posts => _posts.toList();

  set posts(List<Post> value) {
    _posts.assignAll(value);
  }
}
