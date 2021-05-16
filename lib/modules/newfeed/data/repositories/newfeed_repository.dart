import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/newfeed/data/datasources/newfeed_datasources.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';

@lazySingleton
class NewFeedRepository {
  final NewFeedDatasource _newFeedDatasource;

  NewFeedRepository(this._newFeedDatasource);

  Future<List<Post>> getPosts() {
    return _newFeedDatasource.getPosts();
  }

  Future<List<Comment>> getCommentInPost(int postId) {
    return _newFeedDatasource.getCommentsInProject(postId);
  }

  Future<bool> likePost(int idPost) {
    return _newFeedDatasource.likePost(idPost);
  }
}
