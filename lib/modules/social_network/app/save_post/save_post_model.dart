import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_pets_of_user_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SavePostModel extends BaseViewModel {
  final GetPetsOfUserUsecase _getPetsOfUserUsecase;
  late TextEditingController contentController;
  User? _user;
  late final Rx<PostType> _postType = PostType.activity.obs;
  final RxList<MediaFile> _files = <MediaFile>[].obs;
  final RxList<Media> _postMedia = <Media>[].obs;
  final RxBool _isDisable = true.obs;
  final RxList<Pet> _taggedPets = <Pet>[].obs;
  Post? post;
  RxString currentAddress = ''.obs;
  Placemark? currentPlacemark;
  RxBool isLoadingAddress = false.obs;
  Position? currentPosition;

  late bool isPostEditing;

  final List<Media> _deletedMedia = [];

  SavePostModel(
    this._getPetsOfUserUsecase,
  );

  @override
  void initState() {
    super.initState();
    _user = injector<LoggedInUser>().user;
    _postType.value = post?.type ?? PostType.activity;
    _files.stream.listen(onFilesChanged);
    _taggedPets.addAll(post?.taggegPets ?? []);
    _postMedia.addAll(post?.medias ?? []);
    contentController = TextEditingController();
    contentController.addListener(onTextChanged);
    contentController.text = post?.content ?? "";
    getPetsOfUser();
  }

  @override
  void disposeState() {
    contentController.dispose();
    super.disposeState();
  }

  Future getPetsOfUser() async {
    await call(
      () async => user?.currentPets = await _getPetsOfUserUsecase.call(user!.uuid!),
      showLoading: false,
      onSuccess: () {},
    );
  }

  Future onPostTypeChosen(PostType chosenType) async {
    if (isPostEditing) return;

    _postType.value = chosenType;
    // ignore: unrelated_type_equality_checks
    if (_postType != PostType.activity && currentPlacemark == null) {
      bool isResetDisable = false;
      if (!_isDisable.value) {
        _isDisable.value = true;
        isResetDisable = true;
      }
      await _getCurrentAddress();
      if (isResetDisable) _isDisable.value = false;
      return;
    }
    currentPosition = null;
    return;
  }

  Future onMediasPicked(List<MediaFile> pickedFiles) async {
    _files.addAll(pickedFiles);
  }

  Future onRemoveMedia(MediaFile file) async {
    _files.remove(file);
  }

  void onTextChanged() {
    if (contentController.text.isNotEmpty || _files.isNotEmpty) {
      _isDisable.value = false;
    } else {
      _isDisable.value = true;
    }
  }

  void onFilesChanged(List<MediaFile>? event) {
    if ((event != null && event.isNotEmpty) || contentController.text.isNotEmpty) {
      _isDisable.value = false;
    } else {
      _isDisable.value = true;
    }
  }

  void onImageEdited(MediaFile oldFile, MediaFile editedFile) {
    final index = _files.indexOf(oldFile);
    _files.removeAt(index);
    _files.insert(index, editedFile);
  }

  List<Pet> get taggedPets => _taggedPets.toList();
  List<MediaFile> get mediaFiles => _files.toList();

  set taggedPets(List<Pet> value) {
    _taggedPets.assignAll(value);
  }

  bool get isDisable => _isDisable.value;

  set isDisable(bool value) {
    _isDisable.value = value;
  }

  List<MediaFile> get addedMediaFiles => _files;

  List<Media> get postMedias => _postMedia;

  set addedMediaFiles(List<MediaFile> value) {
    _files.assignAll(value);
  }

  PostType get postType => _postType.value;

  set postType(PostType value) {
    _postType.value = value;
  }

  User? get user => _user;

  set user(User? value) {
    _user = value;
  }

  void onTagPet() {
    injector<BottomSheetService>().showTagPetBottomSheet(
      userPets: _user?.currentPets ?? [],
      taggedPets: _taggedPets,
      onPetChosen: _onTaggedPetChosen,
    );
  }

  void _onTaggedPetChosen(Pet pet) {
    if (_taggedPets.contains(pet)) {
      _taggedPets.remove(pet);
    } else {
      _taggedPets.add(pet);
    }
  }

  Future _getCurrentAddress() async {
    final LocationService locationService = injector<LocationService>();
    if (await locationService.isPermissionDenied()) {
      await _showDialogAlert();
    }
    try {
      isLoadingAddress.value = true;
      currentPlacemark = await locationService.getCurrentPlacemark();
      final String address = (currentPlacemark!.street!.isNotEmpty ? '${currentPlacemark!.street!}, ' : '') +
          (currentPlacemark!.locality!.isNotEmpty ? '${currentPlacemark!.locality!}, ' : '') +
          (currentPlacemark!.subAdministrativeArea!.isNotEmpty ? '${currentPlacemark!.subAdministrativeArea!}, ' : '');
      currentAddress.value = address.trim().substring(0, address.length - 2);
    } catch (error) {
      currentAddress.value = error.toString();
    } finally {
      isLoadingAddress.value = false;
    }
    currentPosition = await locationService.determinePosition();
  }

  Future _showDialogAlert() async {
    await injector<DialogService>().showPermisstionDialog();
  }

  void onWantsToContinue() {
    if (isPostEditing) {
      _onSavePost();
    } else {
      _onCreateNewPost();
    }
  }

  void _onSavePost() {
    final EditedPostData editedPostData = EditedPostData(
      oldPost: post!,
      content: contentController.text,
      taggegPets: taggedPets,
      newAddedFiles: mediaFiles,
      deletedMedias: _deletedMedia,
      location: currentPosition == null
          ? null
          : Location(
              long: currentPosition!.longitude,
              lat: currentPosition!.latitude,
              name: currentAddress.value,
            ),
    );
    Get.back(result: editedPostData);
  }

  void _onCreateNewPost() {
    final NewPostData newPostData = NewPostData(
      content: contentController.text,
      type: postType,
      taggegPets: taggedPets,
      mediaFiles: mediaFiles,
      location: currentPosition == null
          ? null
          : Location(
              long: currentPosition!.longitude,
              lat: currentPosition!.latitude,
              name: currentAddress.value,
            ),
    );

    Get.back(result: newPostData);
  }

  void onRemovePostMedia(Media media) {
    _postMedia.remove(media);
    _deletedMedia.add(media);
  }
}
