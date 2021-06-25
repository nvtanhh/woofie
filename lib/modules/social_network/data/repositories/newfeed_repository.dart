import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';

@lazySingleton
class NewFeedRepository {
  final PostDatasource _postDatasource;
  final PetDatasource _petDatasource;
  NewFeedRepository(this._postDatasource, this._petDatasource);

  Future<List<Post>> getPosts() {
    return _postDatasource.getPosts();
  }

  Future<List<Comment>> getCommentInPost(int postId) {
    return _postDatasource.getPostComments(postId);
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
}
