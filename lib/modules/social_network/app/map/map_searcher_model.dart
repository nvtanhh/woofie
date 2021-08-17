import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_service.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@injectable
class MapSearcherModel extends BaseViewModel {
  final GetPostsUsecase _getPostsUsecase;

  final LoggedInUser _loggedInUser;
  final PostService postService;

  MapSearcherModel(this._loggedInUser, this.postService, this._getPostsUsecase);

  List<String> radiuses = [
    '1 kilometer',
    '2 kilometers',
    '3 kilometers',
    '4 kilometers',
    '5 kilometers',
    '10 kilometers',
  ];

  final double _radius = 1000;
  late Set circles;
  late String currentRadius;
  late LatLng initialPosition;
  RxBool _isLoaded = true.obs;
  GoogleMapController? _mapController;

  final int pageSize = 10;
  int nextPageKey = 0;

  bool get isLoaded => _isLoaded.value;

  @override
  void initState() {
    super.initState();
    _initUserLocation();
    _initPostService();
    currentRadius = radiuses[0];
  }

  Future _initUserLocation() async {
    final UserLocation? userLocation = _loggedInUser.user!.location;
    if (userLocation != null) {
      initialPosition = LatLng(userLocation.lat!, userLocation.long!);
    } else {
      final Position currentPosition =
          await injector<LocationService>().determineCurrentPosition();
      initialPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
    }
    _initCircle();
  }

  void _initCircle() {
    circles = {
      Circle(
        circleId: const CircleId("myCircle"),
        radius: _radius,
        center: initialPosition,
        strokeWidth: 1,
        strokeColor: Colors.blue[200]!,
        fillColor: Colors.blue[100]!.withOpacity(.4),
        onTap: () {
          debugPrint('circle pressed');
        },
      )
    };
  }

  void _initPostService() {
    postService.pagingController.addPageRequestListener(
      (pageKey) {
        _loadMorePost(pageKey);
      },
    );
  }

  Future _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getPostsUsecase.call(offset: nextPageKey);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        postService.pagingController.appendLastPage(newItems);
      } else {
        nextPageKey = pageKey + newItems.length;
        postService.pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      postService.pagingController.error = error;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.moveCamera(CameraUpdate.newLatLng(initialPosition));
  }

  double getZoomLevel() {
    double zoomLevel = 11;
    if (_radius > 0) {
      final double radiusElevated = _radius + _radius / 2;
      final double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2)) as double;
    _moveCameraToUserLocation(zoom: zoomLevel);
    return zoomLevel;
  }

  void _moveCameraToUserLocation({double? zoom}) {
    if (_mapController != null) {
      if (zoom == null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(initialPosition));
      } else {
        _mapController!
            .animateCamera(CameraUpdate.newLatLngZoom(initialPosition, zoom));
      }
    }
  }
}
