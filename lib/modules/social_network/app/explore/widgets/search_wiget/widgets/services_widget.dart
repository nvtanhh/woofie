import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/service_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';

class ServicesWidget extends StatelessWidget {
  final PagingController<int, Service> pagingController;

  const ServicesWidget({
    Key? key,
    required this.pagingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Service>(
      padding: EdgeInsets.only(top: 10.h),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, service, index) {
          return ServiceWidget(
            title: service.name ?? "",
            distance: 6,
            widget: ImageWithPlaceHolderWidget(
              imageUrl: service.logo ?? "",
              width: 60.w,
              fit: BoxFit.scaleDown,
            ),
            margin: EdgeInsets.all(10.w),
          );
        },
        newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
        firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
      ),
      pagingController: pagingController,
    );
  }
}
