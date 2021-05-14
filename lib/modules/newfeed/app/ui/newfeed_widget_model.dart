import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/app/ui/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/modules/newfeed/domain/usecases/get_posts_usecase.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
    showMaterialModalBottomSheet(
      context: Get.context,
      builder: (context) => CommentBottomSheetWidget(
        postId: idPost,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          topLeft: Radius.circular(30.r),
        ),
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
