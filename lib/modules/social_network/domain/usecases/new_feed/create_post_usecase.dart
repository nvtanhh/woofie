import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';
import 'package:meowoof/modules/social_network/domain/events/post/post_created_event.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class CreatePostUsecase {
  final NewFeedRepository _newFeedRepository;
  final EventBus _eventBus;
  CreatePostUsecase(this._newFeedRepository, this._eventBus);

  Future<Post> call(Post post) async {
    final newPost = await _newFeedRepository.createPost(post);
    newPost.creator = post.creator;
    newPost.taggegPets = post.taggegPets;
    _eventBus.fire(PostCreatedEvent(newPost));
    return newPost;
  }
}
