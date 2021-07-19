import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/comment_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class NewFeedRepository {
  final PostDatasource _postDatasource;
  final PetDatasource _petDatasource;
  final CommentDatasource _commentDatasource;

  NewFeedRepository(
    this._postDatasource,
    this._petDatasource,
    this._commentDatasource,
  );

  Future<List<Post>> getPosts({int limit = 10, int offset = 0, DateTime? lastValue}) {
    return _postDatasource.getPostsTimeline(offset, limit);
  }

  Future<List<Comment>> getCommentInPost(int postId, int limit, int offset) {
    return _postDatasource.getCommentsInPost(postId, limit, offset);
  }

  Future<bool> likePost(int idPost) {
    return _postDatasource.likePost(idPost);
  }

  Future<List<Pet>> getPetsOfUser(String userUUID) {
    return _petDatasource.getPetsOfUser(userUUID);
  }

  Future<Post> createPost(Post post) {
    return _postDatasource.createPost(post);
  }

  Future<Comment?> createComment(int postId, String content, List<User> userTag) {
    return _commentDatasource.createComment(postId, content, userTag);
  }

  Future<bool> likeComment(int idComment,int idPost,) {
    return _commentDatasource.likeComment(idComment,idPost);
  }

  Future<bool> deletePost(int post) {
    return _postDatasource.deletePost(post);
  }

  Future<Post> refreshPost(int postId) {
    return _postDatasource.getDetailPost(postId);
  }
}
