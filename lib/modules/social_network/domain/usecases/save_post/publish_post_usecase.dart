import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart';
import 'package:meowoof/modules/social_network/domain/events/post/post_created_event.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class PublishUsecase {
  final SavePostRepository _savePostRepository;
  final EventBus _eventBus;
  PublishUsecase(this._savePostRepository, this._eventBus);

  Future<Post?> call(int postId) async {
    final post = await _savePostRepository.publishPost(postId);
    _eventBus.fire(PostCreatedEvent(post!));
    return post;
  }
}
