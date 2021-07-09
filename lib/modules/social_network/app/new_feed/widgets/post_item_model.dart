import 'dart:ui';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

@injectable
class PostItemModel extends BaseViewModel {
  final LikePostUsecase _likePostUsecase;
  final BottomSheetService bottomSheetService = injector<BottomSheetService>();
  final DeletePostUsecase _deletePostUsecase;

  late Post post;
  late VoidCallback onPostDeleted;

  PostItemModel(this._likePostUsecase, this._deletePostUsecase);

  Post get updatablePost => (post.updateSubject.value != Null) ? post.updateSubject.value as Post : post;

  void onCommentClick() {
    bottomSheetService.showComments(post.id);
  }

  void onDeletePost() {
    bool isSuccess = false;
    call(
      () async {
        isSuccess = await _deletePostUsecase.call(post.id);
      },
      onSuccess: () {
        if (isSuccess) {
          injector<ToastService>().success(message: 'Post deleted!', context: Get.context!);
        }
        onPostDeleted();
      },
      onFailure: (err) {
        injector<ToastService>().success(message: err.toString(), context: Get.context!);
      },
    );
  }

  void onLikeClick(int idPost) {
    call(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  void onPostClick() {
    injector<NavigationService>().navigateToPostDetail(post);
  }

  void onWantsToEditPost() {
    injector<NavigationService>().navigateToEditPost(post, _onEditPost);
  }

  void onReportPost() {
    injector<ToastService>().success(message: LocaleKeys.system_comming_soon.trans(), context: Get.context!);
  }

  Future _onEditPost(String newContent, List<Media> deletedMedia, List<MediaFile> newAddedMedia) async {}
}
