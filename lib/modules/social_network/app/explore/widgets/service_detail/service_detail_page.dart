import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/service_detail/service_detail_page_model.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class ServiceDetailPage extends StatefulWidget {
  final Service service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState
    extends BaseViewState<ServiceDetailPage, ServiceDetailPageModel> {
  @override
  void loadArguments() {
    viewModel.service = widget.service;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => viewModel.mapSearcherModel.getZoomLevel(),);
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const MWIcon(
            MWIcons.back,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Column(
                  children: [
                    ImageWithPlaceHolderWidget(
                      imageUrl: viewModel.service.logo ?? "",
                      width: 100.w,
                      height: 60.w,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      viewModel.service.name ?? "",
                      style: UITextStyle.text_header_16_w700,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      viewModel.service.location?.name ?? "",
                      style: UITextStyle.text_body_14_w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        Text(
                          LocaleKeys.profile_description.trans(),
                          style: UITextStyle.text_header_16_w600,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Text(
                      viewModel.service.description ?? "",
                      style: UITextStyle.text_body_14_w600,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              _googleMap(),
            ],
          ),
          Positioned(
            bottom: 20.h,
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(
                      title: LocaleKeys.explore_contact.trans(),
                      width: 280.w,
                      height: 50.h,
                      borderRadius: 15.r,
                      onPress: () => viewModel.onContactClick(),
                    ),
                    GestureDetector(
                      onTap: () => viewModel.openGoogleMap(),
                      child: MWIcon(
                        MWIcons.icGoogleMap,
                        customSize: 47.w,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _googleMap() {
    return Obx(
      () => Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
            ),
          ),
          child: GoogleMap(
            onMapCreated: viewModel.mapSearcherModel.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: viewModel.mapSearcherModel.initialPosition,
              zoom: viewModel.mapSearcherModel.getZoomLevel(),
            ),
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(top: 100),
            circles: viewModel.mapSearcherModel.circles.value,
            markers: viewModel.mapSearcherModel.markers.value,
          ),
        ),
      ),
    );
  }

  @override
  ServiceDetailPageModel createViewModel() =>
      injector<ServiceDetailPageModel>();
}
