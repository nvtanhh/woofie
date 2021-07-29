import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart';

@lazySingleton
class SubscriptionCommentUsecase {
  final NewFeedRepository _newFeedRepository;

  SubscriptionCommentUsecase(this._newFeedRepository);

  Future<Snapshot> run(int postId) {
    return _newFeedRepository.subscriptionComment(postId);
  }
}
