import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionPetDetailWidgetModel extends BaseViewModel {
  final Rxn<Post> _post = Rxn<Post>();
  final GetDetailPostUsecase _getDetailPostUsecase;
  final RxBool _isLoaded = RxBool(false);
  AdoptionPetDetailWidgetModel(this._getDetailPostUsecase);

  @override
  void initState() {
    getPostDetail();
    super.initState();
  }

  Future getPostDetail() async {
    await call(
      () async {
        post.update(await _getDetailPostUsecase.call(post.id));
      },
      showLoading: false,
    );
  }

  Pet get taggedPet => post.taggegPets![0].updateSubjectValue;

  Post get post => _post.value!;

  set post(Post post) {
    _post.value = post;
  }

  @override
  void disposeState() {
    _isLoaded.close();
    super.disposeState();
  }
}
