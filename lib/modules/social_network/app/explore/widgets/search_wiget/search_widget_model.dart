import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/delay_action_helper.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/search_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/search_service_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/follow_pet_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SearchWidgetModel extends BaseViewModel {
  final SearchPetUsecase _searchPetUsecase;
  final SearchServiceUsecase _searchServiceUsecase;
  final FollowPetUsecase _followPetUsecase;
  late TabController tabController;
  final RxList<Pet> _pets = RxList<Pet>();
  final RxList<Service> _services = RxList<Service>();

  final int pageSize = 10;
  final PagingController<int, Pet> petPagingController = PagingController<int, Pet>(firstPageKey: 0);
  final PagingController<int, Service> servicePagingController = PagingController<int, Service>(firstPageKey: 0);
  String? keyWord;
  final DelayActionHelper _delayActionHelper = DelayActionHelper(milliseconds: 500);

  SearchWidgetModel(
    this._searchPetUsecase,
    this._searchServiceUsecase,
    this._followPetUsecase,
  );

  @override
  void initState() {
    searchData();
    super.initState();
  }

  void onSearch(String value) {
    if (value == keyWord) return;
    keyWord = value;
    _delayActionHelper.run(
      () {
        if (tabController.index == 0) {
          searchPets(keyWord ?? "");
        } else if (tabController.index == 1) {
          searchServices(keyWord ?? "");
        }
      },
    );
  }

  Future searchPets(String keyWord) async {
    petPagingController.itemList?.clear();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    petPagingController.notifyListeners();
    await call(
      () async => pets = await _searchPetUsecase.call(keyWord),
      showLoading: false,
    );
    if (pets.length == pageSize) {
      petPagingController.appendPage(pets, pets.length);
    } else {
      petPagingController.appendLastPage(pets);
    }
  }

  Future searchServices(String keyWord) async {
    servicePagingController.itemList?.clear();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    servicePagingController.notifyListeners();
    await call(
      () async => services = await _searchServiceUsecase.call(keyWord),
      showLoading: false,
    );
    if (services.length == pageSize) {
      servicePagingController.appendPage(services, pets.length);
    } else {
      servicePagingController.appendLastPage(services);
    }
  }

  void followPet(int idPet) {
    call(
          () async => _followPetUsecase.call(idPet),
      showLoading: false,
    );
  }
  void searchData() {
    if (keyWord?.isEmpty == true) return;
    if (pets.isEmpty && tabController.index == 0) {
      searchPets(keyWord ?? "");
    } else if (services.isEmpty && tabController.index == 1) {
      searchServices(keyWord ?? "");
    }
  }

  void onTab(int index) {
    searchData();
  }

  List<Pet> get pets => _pets.toList();

  set pets(List<Pet> value) {
    _pets.assignAll(value);
  }

  List<Service> get services => _services.toList();

  set services(List<Service> value) {
    _services.assignAll(value);
  }

  @override
  void disposeState() {
    petPagingController.dispose();
    servicePagingController.dispose();
    tabController.dispose();

    super.disposeState();
  }
}
