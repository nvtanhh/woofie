import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_post_by_type_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionWidgetModel extends BaseViewModel {
  final int pageSize = 10;
  int nextPageKey = 0;
  late PagingController<int, Post> pagingController;
  final GetPostByTypeUsecase _getPostByTypeUsecase;
  List<Post>? posts = [];
  late PostType postType;
  AdoptionWidgetModel(this._getPostByTypeUsecase) {
    pagingController = PagingController(firstPageKey: 0);
  }

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _loadPost(pageKey);
    });
    super.initState();
  }

  void _loadPost(int pageKey) {
    call(
        () async {
          posts = await _getPostByTypeUsecase.call(
            postType: postType,
          );
          if ((posts?.length ?? 0) < pageSize) {
            pagingController.appendLastPage(posts ?? []);
          } else {
            nextPageKey = pageKey + (posts?.length ?? 0);
            pagingController.appendPage(posts ?? [], nextPageKey);
          }
        },
        showLoading: false,
        onSuccess: () {},
        onFailure: (err) {
          pagingController.error = err;
        });
  }

  void onItemClick(Post post) {
    Get.to(() => AdoptionPetDetailWidget(post: post));
  }

  Future onRefresh() async {
    pagingController.refresh();
    return;
  }
}
