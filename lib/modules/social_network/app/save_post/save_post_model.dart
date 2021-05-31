import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SavePostModel extends BaseViewModel {
  final TextEditingController contentController = TextEditingController();

  late User _user;
  late final Rx<PostType> _postType = PostType.activity.obs;
  final RxList<MediaFile> _files = <MediaFile>[].obs;
  final RxBool _isDisable = true.obs;
  final RxList<Pet> _taggedPets = <Pet>[].obs;
  Post? post;
  RxString currentAdress = ''.obs;
  Placemark? currentPlacemark;
  RxBool isLoadingAddress = false.obs;

  @override
  void initState() {
    super.initState();
    try {
      _user = post != null ? post!.creator : injector<LoggedInUser>().loggedInUser;
    } catch (error) {
      _user = User(
        id: 7,
        name: 'Tanh Nguyen',
        avatarUrl:
            'https://scontent.fhan2-3.fna.fbcdn.net/v/t1.6435-9/162354720_1147808662336518_1297648803267744126_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=P68qZDEZZXIAX826eFN&_nc_ht=scontent.fhan2-3.fna&oh=e10ef4fe2b17089b3f9071aa6d611366&oe=60CEC5D6',
        pets: [
          Pet(id: 1, name: "Vàng", avatar: 'https://p0.pikist.com/photos/657/191/cat-animal-eyes-kitten-head-cute-nature-predator-look-feline.jpg'),
          Pet(id: 2, name: "Đỏ", avatar: 'https://p0.pikist.com/photos/389/595/animal-cat-cute-domestic-eyes-face-feline-fur-head.jpg'),
        ],
      );
    }
    _postType.value = post != null ? post!.type : PostType.activity;

    contentController.addListener(onTextChanged);
    _files.stream.listen(onFilesChanged);
    // _taggedPets.addAll(_user.pets ?? []);
  }

  Future onPostTypeChosen(PostType chosenType) async {
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
    }
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

  set taggedPets(List<Pet> value) {
    _taggedPets.assignAll(value);
  }

  bool get isDisable => _isDisable.value;

  set isDisable(bool value) {
    _isDisable.value = value;
  }

  List<MediaFile> get files => _files;

  set files(List<MediaFile> value) {
    _files.assignAll(value);
  }

  PostType get postType => _postType.value;

  set postType(PostType value) {
    _postType.value = value;
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  void onTagPet() {
    injector<BottomSheetService>().showTagPetBottomSheet(
      userPets: _user.pets ?? [],
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
      currentAdress.value = address.trim().substring(0, address.length - 2);
    } catch (error) {
      currentAdress.value = error.toString();
    } finally {
      isLoadingAddress.value = false;
    }
  }

  Future _showDialogAlert() async {
    await injector<DialogService>().showPermisstionDialog();
  }
}
