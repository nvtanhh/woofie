import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/map/map_searcher_model.dart';
import 'package:suga_core/suga_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapSearcher extends StatefulWidget {
  const MapSearcher({Key? key}) : super(key: key);

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
                  _buildSearchBar(),
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
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: GoogleMap(
        
        onMapCreated: viewModel.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: viewModel.initialPosition,
          zoom: viewModel.getZoomLevel(),
        ),
        markers: viewModel.markers,
        zoomControlsEnabled: false,
        padding: const EdgeInsets.only(top: 100),
        circles: viewModel.circles,
        myLocationEnabled: true,
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox();
  }

  Widget _buildPostsWrapper() {
    return const SizedBox();
  }
}
