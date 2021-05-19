import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionWidgetModel extends BaseViewModel {
  final int pageSize = 10;
  late PagingController<int, Post> pagingController;
  final GetPostsUsecase _getPostsUsecase;
  List<Post>? posts = [];

  AdoptionWidgetModel(this._getPostsUsecase) {
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
        posts = await _getPostsUsecase.call();
        if ((posts?.length ?? 0) < pageSize) {
          pagingController.appendLastPage(posts ?? []);
        } else {
          final nextPageKey = pageKey + (posts?.length ?? 0);
          pagingController.appendPage(posts ?? [], nextPageKey);
        }
      },
      showLoading: false,
      onSuccess: () {},
    );
  }
}
