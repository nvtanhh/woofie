import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NotificationWidgetModel extends BaseViewModel {
  final pageSize = 10;
  int nextPageKey = 0;
  late PagingController<int, Notification> pagingController;
  List<Notification> notifications = [];

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: nextPageKey);
    super.initState();
  }

  Future onRefresh() async {}
}
