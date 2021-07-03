import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionPetDetailWidgetModel extends BaseViewModel {
  late Post post;
  Pet? pet;
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
        post = await _getDetailPostUsecase.call(post.id);
      },
      onSuccess: () {
        isLoaded = true;
      },
      onFailure: (err) {},
    );
  }

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }

  @override
  void disposeState() {
    _isLoaded.close();
    super.disposeState();
  }
}
