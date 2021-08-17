import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/map/map_searcher_model.dart';
import 'package:suga_core/suga_core.dart';

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
                  _googleMap(context),
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

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: viewModel.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: viewModel.initialPosition,
          zoom: viewModel.getZoomLevel(),
        ),
        markers: _allMarkers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
        padding: EdgeInsets.only(top: 100),
        circles: _circles,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox();
  }

  Widget _buildPostsWrapper() {
    return SizedBox();
  }


  
}
