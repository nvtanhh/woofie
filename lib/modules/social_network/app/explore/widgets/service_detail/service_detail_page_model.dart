import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/map/map_searcher_model.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class ServiceDetailPageModel extends BaseViewModel {
  final MapSearcherModel mapSearcherModel;
  late Service service;

  ServiceDetailPageModel(this.mapSearcherModel);

  @override
  void initState() {
    mapSearcherModel.initialPosition = LatLng(
      service.location!.lat!,
      service.location!.long!,
    );
    mapSearcherModel.markers.add(
      Marker(
        markerId: const MarkerId("markerId"),
        position: mapSearcherModel.initialPosition,
      ),
    );
    mapSearcherModel.initCircle();
    super.initState();
  }

  Future openGoogleMap() async {
    final mapSchema = 'geo:${service.location!.lat!},${service.location!.long!}';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    }else {
      injector<ToastService>().toast(message: "Lỗi!", type: ToastType.error, context: Get.context!);
    }
  }

  Future onContactClick() async {
    final url = 'tel://${service.phoneNumber}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      injector<ToastService>().toast(message: "Lỗi!", type: ToastType.error, context: Get.context!);
    }
  }

  @override
  void disposeState() {
    mapSearcherModel.disposeState();
    super.disposeState();
  }
}
