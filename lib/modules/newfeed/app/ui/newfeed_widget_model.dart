import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
  final RxList<Post> _posts = RxList<Post>();

  List<Post> get posts => _posts.toList();

  set posts(List<Post> value) {
    _posts.assignAll(value);
  }
}
