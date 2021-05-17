import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class NewFeedRepository {
  final PostDatasource _newFeedDatasource;

  NewFeedRepository(this._newFeedDatasource);

  Future<List<Post>> getPosts() {
    return _newFeedDatasource.getPosts();
  }

  Future<List<Comment>> getCommentInPost(int postId) {
    return _newFeedDatasource.getPostComments(postId);
  }

  Future<bool> likePost(int idPost) {
    return _newFeedDatasource.likePost(idPost);
  }
}
