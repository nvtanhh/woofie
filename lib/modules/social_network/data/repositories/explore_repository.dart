import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';

@lazySingleton
class ExploreRepository {
  final PostDatasource _postDatasource;
  final PetDatasource _petDatasource;

  ExploreRepository(this._postDatasource, this._petDatasource);

  Future<List<Service>> getServicesPet() async {
    return [];
  }

  Future<List<Post>> getPostsByType(
    PostType postType,
    double longUser,
    double latUser,
    int limit,
    int offset,
  ) async {
    return _postDatasource.getPostByType(
      postType,
      longUser,
      latUser,
      limit,
      offset,
    );
  }

  Future<Post> getDetailPost(int postId) {
    return _postDatasource.getDetailPost(postId);
  }

  Future<List<Service>> searchService(String keyWord) async {
    await Future.delayed(const Duration(seconds: 1));
    if (keyWord.isEmpty) {
      return <Service>[];
    } else {
      return <Service>[
        Service(
          id: 0,
          name: "Animal Emergency",
          logo: "https://animalemergencyhospital.net/wp-content/uploads/2021/04/animal-emergency-hospital.png",
        ),
        Service(
          id: 1,
          name: "Công Ty TNHH Kimipet Việt Nam",
          logo: "https://kimipet.vn/wp-content/uploads/2017/05/logo.png",
        ),
        Service(
          id: 2,
          name: "Bệnh Viện Thú Y Petcare",
          logo: "https://petcare.vn/wp-content/uploads/2016/06/petcarevn_logo.png",
        ),
      ];
    }
  }

  Future<List<Pet>> searchPet(String keyWord, int offset, int limit) {
    return _petDatasource.searchPet(keyWord, offset, limit);
  }
}
