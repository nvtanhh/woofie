import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/map/map_searcher_model.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/post_item_map.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MapSearcher extends StatefulWidget {
  const MapSearcher({super.key});

  @override
  _MapSearcherState createState() => _MapSearcherState();
}

class _MapSearcherState extends BaseViewState<MapSearcher, MapSearcherModel> {
  @override
  MapSearcherModel createViewModel() => injector<MapSearcherModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: Stack(
                children: <Widget>[
                  _googleMap(),
                  if (viewModel.isLoaded) _buildSearchBar(),
                  if (viewModel.isLoaded) _buildPostsWrapper(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _googleMap() {
    return Obx(
      () => SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: GoogleMap(
          onMapCreated: viewModel.onMapCreated,
          initialCameraPosition: CameraPosition(
            target: viewModel.initialPosition,
            zoom: viewModel.getZoomLevel(),
          ),
          markers: viewModel.markers.toSet(),
          zoomControlsEnabled: false,
          padding: const EdgeInsets.only(top: 100),
          circles: viewModel.circles.toSet(),
          myLocationEnabled: true,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
      decoration: BoxDecoration(
        color: UIColor.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.r),
          bottomLeft: Radius.circular(25.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const MWIcon(
              MWIcons.back,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 20.w),
          Obx(
            () => Expanded(
              child: Row(
                children: [
                  const Text(
                    'Radius: ',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white,
                            isExpanded: true,
                            value: viewModel.currentRadius.value,
                            selectedItemBuilder: (_) {
                              return viewModel.radiuses
                                  .map(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: UITextStyle.white_14_w500,
                                      ),
                                    ),
                                  )
                                  .toList();
                            },
                            items: viewModel.radiuses
                                .map(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: UITextStyle.text_body_14_w500,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: viewModel.onChangedChoosenRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    height: 30.h,
                    child: VerticalDivider(color: Colors.white, width: 2.w),
                  ),
                  _filterButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsWrapper() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 156.h,
        child: PagedListView<int, Post>(
          scrollDirection: Axis.horizontal,
          scrollController: viewModel.scrollController,
          padding: EdgeInsets.only(left: 16.w, bottom: 10.h, top: 10.h),
          pagingController: viewModel.postService.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, post, index) {
              viewModel.calculateDistance(post);
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: PostMapWidget(post: post),
              );
            },
            newPageErrorIndicatorBuilder: (_) => const SizedBox(),
            firstPageErrorIndicatorBuilder: (_) => const SizedBox(),
            noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
            noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
            newPageProgressIndicatorBuilder: (_) => const SizedBox(),
            firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget _filterButton() {
    return IconButton(
      onPressed: viewModel.onFilterPressed,
      icon: Stack(
        children: [
          MWIcon(
            MWIcons.filter,
            color: UIColor.accent,
          ),
          Obx(
            () => viewModel.filterOptions != null
                ? Positioned(
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(3.w, 0),
                      child: SizedBox(
                        height: 8.w,
                        width: 8.w,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: UIColor.accent,
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
