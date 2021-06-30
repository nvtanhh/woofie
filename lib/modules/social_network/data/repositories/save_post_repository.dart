import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';

@lazySingleton
class SavePostRepository {
  final PostDatasource _postDatasource;

  SavePostRepository(this._postDatasource);

  Future<Post?> createDraftPost(NewPostData data) async {
    return _postDatasource.createDraftPost(data);
  }
}
