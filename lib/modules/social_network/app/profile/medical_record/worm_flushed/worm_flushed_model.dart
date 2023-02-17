import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_worm_flushed_dialog.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_worm_flushed_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_worm_flush_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_worm_flushes_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_worm_flush_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WormFlushedWidgetModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  final RxList<PetWormFlushed> _wormFlushes = RxList<PetWormFlushed>();
  final GetWormFlushesUsecase _getWormFlushesUsecase;
  final AddWormFlushedUsecase _addWormFlushedUsecase;
  final DeletePetWormFlushUsecase _deletePetWormFlushUsecase;
  final UpdatePetWormFlushUsecase _updatePetWormFlushUsecase;
  final DialogService _dialogService;
  final ToastService _toastService;
  bool isLastPage = false;
  int pageSize = 10, pageKey = 0;
  List<PetWormFlushed> receiveWormFlushed = [];
  PetWormFlushed? wormFlushed;

  WormFlushedWidgetModel(
    this._getWormFlushesUsecase,
    this._addWormFlushedUsecase,
    this._toastService,
    this._deletePetWormFlushUsecase,
    this._updatePetWormFlushUsecase,
    this._dialogService,
  );

  @override
  void initState() {
    getWormFlushes();
    super.initState();
  }

  Future showDialogAddWeight() async {
    wormFlushed = null;
    wormFlushed = await Get.dialog(
      AddWormFlushedDialog(),
    );
    if (wormFlushed == null) {
      return;
    }
    wormFlushed!.petId = pet.id;
    await run(
      () async {
        final wormF = await _addWormFlushedUsecase.call(wormFlushed!);
        wormFlushed!.id = wormF.id;
      },
      onSuccess: () {
        _wormFlushes.insert(0, wormFlushed!);
        updatePreviewWormFlush();
        _wormFlushes.refresh();
      },
      onFailure: (err) {
        printError(info: err.toString());
        _toastService.error(
            message: LocaleKeys.error.trans(), context: Get.context!);
      },
    );
  }

  void updatePreviewWormFlush() {
    sortByDate();
    if (_wormFlushes.length > 2) {
      pet.petWormFlushes = _wormFlushes.sublist(0, 2);
    } else {
      pet.petWormFlushes = _wormFlushes.toList();
    }
    pet.notifyUpdate();
  }

  Future getWormFlushes() async {
    if (isLastPage) return;
    await run(
      () async {
        receiveWormFlushed = await _getWormFlushesUsecase.call(
          pet.id,
          offset: _wormFlushes.length,
        );

        if (receiveWormFlushed.length < pageSize) {
          isLastPage = true;
        }
      },
      showLoading: false,
      onSuccess: () {
        _wormFlushes.addAll(receiveWormFlushed);
      },
      onFailure: (err) {
        printError(info: err.toString());
      },
    );
  }

  void deletePetWormFlushed(PetWormFlushed wormFlush, int index) {
    run(
      () async => _deletePetWormFlushUsecase.run(wormFlush.id),
      onSuccess: () {
        _wormFlushes.removeAt(index);
        updatePreviewWormFlush();
        _wormFlushes.refresh();
      },
    );
  }

  void onDelete(PetWormFlushed wormFlush, int index) {
    _dialogService
        .showDialogConfirmDelete(() => deletePetWormFlushed(wormFlush, index));
  }

  Future onEdit(PetWormFlushed wormFlush, int index) async {
    wormFlushed = null;
    wormFlushed = await Get.dialog(
      AddWormFlushedDialog(
        petWormFlushed: wormFlush,
      ),
    );
    if (wormFlushed == null) {
      return;
    }
    await run(
      () async => wormFlushed = await _updatePetWormFlushUsecase.run(wormFlush),
      onSuccess: () {
        _wormFlushes[index] = wormFlushed!;
        updatePreviewWormFlush();
        _wormFlushes.refresh();
      },
    );
  }

  void sortByDate() {
    _wormFlushes.sort((a, b) {
      return a.date!.compareTo(b.date!) >= 0 ? -1 : 1;
    });
  }

  List<PetWormFlushed> get wormFlushes => _wormFlushes.toList();

  @override
  void disposeState() {
    _wormFlushes.close();
    super.disposeState();
  }
}
