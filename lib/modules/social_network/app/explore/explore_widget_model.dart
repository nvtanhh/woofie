import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/adoption_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/search_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_services_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_location_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ExploreWidgetModel extends BaseViewModel {
  final GetServicesPetUsecase _getServicesPetUsecase;
  final UpdateLocationUsecase _updateLocationUsecase;
  final RxList<Service> _services = RxList<Service>();
  UserLocation? userLocation;

  ExploreWidgetModel(this._getServicesPetUsecase, this._updateLocationUsecase);

  @override
  void initState() {
    getUserLocal();
    getServices();
    super.initState();
  }

  Future getUserLocal() async {
    userLocation = await getUserLocation(injector<LoggedInUser>().user!);
  }

  void getServices() {
    call(
      () async => services = await _getServicesPetUsecase.call(),
      showLoading: false,
    );
  }

  // hot fix. duplicate with postService
  Future<void> _checkAndUpdateUserLocation(UserLocation userLocation) async {
    if (userLocation.updatedAt == null) return;
    if (DateTime.now().difference(userLocation.updatedAt!).inMinutes > 30) {
      final Position currentPosition = await injector<LocationService>().determineCurrentPosition();
      userLocation.lat = currentPosition.latitude;
      userLocation.long = currentPosition.longitude;
      unawaited(updateLocation(userLocation));
    }
    return;
  }

  Future updateLocation(UserLocation location) async {
    await call(
      () async => _updateLocationUsecase.run(
        id: location.id!,
        long: location.long!,
        lat: location.lat!,
        name: location.name!,
      ),
      showLoading: false,
    );
    return;
  }

  Future<UserLocation?> getUserLocation(User user) async {
    try {
      final UserLocation? userLocation = user.location;
      if (userLocation != null) {
        unawaited(_checkAndUpdateUserLocation(userLocation));
        return userLocation;
      } else {
        final Position currentPosition = await injector<LocationService>().determineCurrentPosition();
        final userLocation = UserLocation(lat: currentPosition.latitude, long: currentPosition.longitude);
        // unawaited(updateLocation(userLocation));
        return userLocation;
      }
    } catch (e) {
      return null;
    }
  }

  double calculateDistance(UserLocation location) {
    if (userLocation != null) {
      return (Geolocator.distanceBetween(
                userLocation!.lat!,
                userLocation!.long!,
                location.lat!,
                location.long!,
              ) /
              1000)
          .toPrecision(1);
    }
    return 3;
  }

  void onSearchBar(String string) {}

  void onSubmitted(String value) {
    if (value.isEmpty) return;
    Get.to(
      () => SearchWidget(
        textSearch: value,
      ),
    );
  }

  void onLocationClick() {
    injector<NavigationService>().navigateToMapSearcher();
  }

  void onAdoptionClick() {
    Get.to(() => const AdoptionWidget(postType: PostType.adop));
  }

  void onMattingClick() {
    Get.to(() => const AdoptionWidget(postType: PostType.mating));
  }

  void onLoseClick() {
    Get.to(() => const AdoptionWidget(postType: PostType.lose));
  }

  List<Service> get services => _services;

  set services(List<Service> value) {
    _services.assignAll(value);
  }
}
