import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionWidgetModel extends BaseViewModel {
  final int pageSize = 10;
  late PagingController<int, Post> pagingController;

  AdoptionWidgetModel() {
    pagingController = PagingController(firstPageKey: 0);
  }
}
