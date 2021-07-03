import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/adoption_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/search_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ExploreWidgetModel extends BaseViewModel {
  void onSearchBar(String string) {}

  void onSubmitted(String value) {
    if (value.isEmpty) return;
    Get.to(
      () => SearchWidget(
        textSearch: value,
      ),
    );
  }

  void onLocationClick() {}

  void onAdoptionClick() {
    Get.to(() => const AdoptionWidget(postType: PostType.adop));
  }

  void onMattingClick() {
    Get.to(() => const AdoptionWidget(postType: PostType.mating));
  }

  void onLoseClick() {
    Get.to(() => const AdoptionWidget(postType: PostType.lose));
  }
}
