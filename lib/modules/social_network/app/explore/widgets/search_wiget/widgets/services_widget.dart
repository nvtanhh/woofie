import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/service_detail/service_detail_page.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/service_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';

class ServicesWidget extends StatelessWidget {
  final PagingController<int, Service> pagingController;
  final UserLocation userLocation;

  const ServicesWidget({
    Key? key,
    required this.pagingController,
    required this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Service>(
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, service, index) {
          return GestureDetector(
            onTap: () => Get.to(() => ServiceDetailPage(service: service)),
            child: ServiceWidget(
              title: service.name ?? "",
              distance: calculateDistance(service.location!),
              widget: ImageWithPlaceHolderWidget(
                imageUrl: service.logo ?? "",
                width: 60.w,
                fit: BoxFit.scaleDown,
              ),
              margin: EdgeInsets.all(10.w),
            ),
          );
        },
        newPageProgressIndicatorBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
        firstPageProgressIndicatorBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      ),
      pagingController: pagingController,
    );
  }

  double calculateDistance(UserLocation location) {
    return (Geolocator.distanceBetween(
              userLocation.lat!,
              userLocation.long!,
              location.lat!,
              location.long!,
            ) /
            1000)
        .roundToDouble();
  }
}
