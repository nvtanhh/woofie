import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_service.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_post_by_location.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MapSearcherModel extends BaseViewModel {
  final GetPostByLocationUsecase _getPostByLocationUsecase;

  final LoggedInUser _loggedInUser;
  final PostService postService;

  final ScrollController scrollController = ScrollController();

  MapSearcherModel(
    this._loggedInUser,
    this.postService,
    this._getPostByLocationUsecase,
  );

  List<String> radiuses = [
    '1 kilometer',
    '2 kilometers',
    '3 kilometers',
    '4 kilometers',
    '5 kilometers',
    '10 kilometers',
    '20 kilometers',
  ];

  int _radiusByKm = 1;

  RxSet<Circle> circles = <Circle>{}.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxString currentRadius = ''.obs;
  static const double DEFAULTZOOMLEVEL = 12.0;
  LatLng initialPosition = const LatLng(10.8546928, 106.7181451);
  // Ho Chi Minh City is default Position
  final RxBool _isLoaded = false.obs;
  GoogleMapController? _mapController;

  final int pageSize = 10;
  int nextPageKey = 0;

  bool get isLoaded => _isLoaded.value;

  @override
  void initState() {
    super.initState();
    _initUserLocation();
    _initPostService();
    currentRadius.value = radiuses[0];
  }

  Future _initUserLocation() async {
    // final UserLocation? userLocation = _loggedInUser.user!.location;
    // if (userLocation != null) {
    //   initialPosition = LatLng(userLocation.lat!, userLocation.long!);
    // } else {
    // }
    final Position currentPosition =
        await injector<LocationService>().determineCurrentPosition();
    initialPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    _isLoaded.value = true;
    getZoomLevel();
    initCircle();
  }

  void initCircle() {
    circles.clear();
    circles.add(Circle(
      circleId: const CircleId("myCircle"),
      radius: _radiusByKm * 1000,
      center: initialPosition,
      strokeWidth: 1,
      strokeColor: UIColor.primary.withOpacity(.4),
      fillColor: UIColor.primary.withOpacity(.05),
      onTap: () {
        debugPrint('circle pressed');
      },
    ));
  }

  void _initPostService() {
    postService.initState();
    postService.pagingController.addPageRequestListener(
      (pageKey) {
        _loadMorePost(pageKey);
      },
    );
  }

  Future _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getPostByLocationUsecase.call(
        lat: initialPosition.latitude,
        long: initialPosition.longitude,
        radius: _radiusByKm,
      );
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        postService.pagingController.appendLastPage(newItems);
      } else {
        nextPageKey = pageKey + newItems.length;
        postService.pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      postService.pagingController.error = error;
    } finally {
      final List<Post> posts = postService.pagingController.itemList ?? [];
      unawaited(_drawMarker(posts));
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.moveCamera(CameraUpdate.newLatLng(initialPosition));
    // Remove POI layer
    rootBundle.loadString('resources/map_style.txt').then((mapStyle) {
      _mapController!.setMapStyle(mapStyle);
    });
  }

  double getZoomLevel() {
    if (!isLoaded) {
      _moveCameraToUserLocation(zoom: DEFAULTZOOMLEVEL);
      return DEFAULTZOOMLEVEL;
    }
    double zoomLevel = 11;
    final double radiusByMetter = _radiusByKm * 1000;
    if (radiusByMetter > 0) {
      final double radiusElevated = radiusByMetter + radiusByMetter / 2;
      final double scale = radiusElevated / 600;
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

  Future<void> _drawMarker(List<Post> posts) async {
    // markers.clear();
    for (final Post post in posts) {
      final icon =
          await _getCustomIcon(post.medias![0].url!, post.taggegPets![0].name!);

      if (icon != null &&
          post.location?.lat != null &&
          post.location?.long != null) {
        final double lat = post.location!.lat!;
        final double long = post.location!.long!;
        markers.add(
          Marker(
            markerId: MarkerId(post.id.toString()),
            icon: icon,
            position: LatLng(lat, long),
            infoWindow: InfoWindow(
              title: post.taggegPets![0].name,
            ),
          ),
        );
      }
    }
  }

  Future<BitmapDescriptor?> _getCustomIcon(String url, String petName) async {
    Size size = Size(150.0, 150.0);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = UIColor.primary.withAlpha(80);
    const double shadowWidth = 15.0;
    const double borderWidth = 3.0;
    const double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint,
    );

    // Oval for the image
    final Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    final Uint8List imageBytes = await markerImageFile.readAsBytes();

    final ui.Codec imageCodec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();

    ui.Image image = frameInfo.image;
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final Uint8List uint8List = byteData.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(uint8List);
    } else {
      return null;
    }
  }

  void calculateDistance(Post post) {
    postService.calculateDistance(post);
  }

  void onChangedChoosenRadius(String? value) {
    if (value == null) return;
    currentRadius.value = value;
    _radiusByKm = int.parse(
      currentRadius.substring(
        0,
        currentRadius.indexOf(' '),
      ),
    );
    initCircle();
    postService.pagingController.refresh();
  }
  @override
  void disposeState() {
    _mapController?.dispose();
    super.disposeState();
  }
}
