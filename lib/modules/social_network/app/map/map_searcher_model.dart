import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/filter/models/filter_option.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_post_by_location.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MapSearcherModel extends BaseViewModel {
  final GetPostByLocationUsecase _getPostByLocationUsecase;

  final PostService postService;
  final ScrollController scrollController = ScrollController();
  final Rxn<FilterOptions> _filterOptions = Rxn();

  List<Post>? _allPosts;

  MapSearcherModel(
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

  FilterOptions? get filterOptions => _filterOptions.value;
  set filterOptions(FilterOptions? value) => _filterOptions.value = value;

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
      await _sortByDistance(newItems);
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
      _allPosts = postService.pagingController.itemList ?? [];
      unawaited(_drawMarkers(_allPosts!));
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

  Future<void> _drawMarkers(List<Post> posts) async {
    _removeUnnesseryMarkers(posts);
    for (final Post post in posts) {
      final icon = await _getCustomIcon(post);

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

  Future<BitmapDescriptor?> _getCustomIcon(Post post) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    Color color;
    switch (post.type) {
      case PostType.adop:
        color = UIColor.adoptionColor;
        break;
      case PostType.mating:
        color = UIColor.matingColor;
        break;
      case PostType.lose:
        color = UIColor.danger;
        break;
      default:
        color = UIColor.primary;
    }

    final Paint shadowPaint = Paint()..color = color.withAlpha(80);
    const double shadowWidth = 15.0;
    const double borderWidth = 3.0;
    const double imageOffset = shadowWidth + borderWidth;

    const Size size = Size(150.0, 150.0);
    final Radius radius = Radius.circular(size.width / 2);

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

    final String url =
        ((post.medias?.isNotEmpty ?? false) && post.medias![0].url != null)
            ? post.medias![0].url!
            : post.taggegPets?[0].avatarUrl ?? '';
    late Uint8List imageBytes;
    if (url.isNotEmpty) {
      final markerImageFile = await DefaultCacheManager().getSingleFile(url);
      imageBytes = await markerImageFile.readAsBytes();
    } else {
      final ByteData bytes = await rootBundle
          .load('resources/images/fallbacks/pet-avatar-fallback.jpg');
      imageBytes = bytes.buffer.asUint8List();
    }

    // Add image
    final ui.Codec imageCodec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();

    final ui.Image image = frameInfo.image;
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

  Future<void> _sortByDistance(List<Post> posts) async {
    posts.forEach(_calculateDistance);
    posts
        .sort((a, b) => a.distanceUserToPost!.compareTo(b.distanceUserToPost!));
  }

  void _calculateDistance(Post post) {
    post.distanceUserToPost ??= (Geolocator.distanceBetween(
              initialPosition.latitude,
              initialPosition.longitude,
              post.location!.lat!,
              post.location!.long!,
            ) /
            1000)
        .toPrecision(1);
  }

  void _removeUnnesseryMarkers(List<Post> posts) {
    markers.removeWhere(
        (m) => !posts.any((post) => post.id.toString() == m.markerId.value));
  }

  Future onFilterPressed() async {
    final FilterOptions? filter = await injector<BottomSheetService>()
        .showMapSeacherFilterBottomSheet(currentFilter: filterOptions);
    if (filter != null) {
      if (filter.isClearFilter) {
        filterOptions = null;
        if (_allPosts != null) {
          _setPostItems(_allPosts);
          unawaited(_drawMarkers(_allPosts!));
        }
      } else {
        filterOptions = filter;
        _filterResult();
      }
    }
  }

  void _filterResult() {
    final filteredPosts = _allPosts?.where((post) {
      final bool postTypeFilterResult =
          (filterOptions?.selectedPostTypes?.isEmpty ?? true) ||
              (filterOptions?.selectedPostTypes?.contains(post.type) ?? true);
      final bool petTypeFilterResult = (filterOptions?.selectedPetType ==
              null) ||
          (filterOptions?.selectedPetType == post.taggegPets?.first.petType);
      final bool petBreedFilterResult =
          (filterOptions?.selectedPetBreeds?.isEmpty ?? true) ||
              (filterOptions?.selectedPetBreeds
                      ?.contains(post.taggegPets?.first.petBreed) ??
                  true);
      return postTypeFilterResult &&
          petTypeFilterResult &&
          petBreedFilterResult;
    }).toList();

    _setPostItems(filteredPosts);
    _removeUnnesseryMarkers(filteredPosts ?? []);
  }

  void _setPostItems(List<Post>? posts) {
    if (posts != null) {
      postService.pagingController.itemList = posts;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      postService.pagingController.notifyListeners();
    }
  }
}
