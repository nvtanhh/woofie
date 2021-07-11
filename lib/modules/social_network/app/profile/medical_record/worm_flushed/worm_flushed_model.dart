import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_worm_flushed_dialog.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_worm_flushed_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_worm_flushes_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WormFlushedWidgetModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  final RxList<PetWormFlushed> _wormFlushes = RxList<PetWormFlushed>();
  final GetWormFlushesUsecase _getWormFlushesUsecase;
  final AddWormFlushedUsecase _addWormFlushedUsecase;
  final ToastService _toastService;
  bool isLastPage = false;
  int pageSize = 10, pageKey = 0;
  List<PetWormFlushed> receiveWormFlushed = [];
  PetWormFlushed? wormFlushed;

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
    await call(
      () async {
        final wormF = await _addWormFlushedUsecase.call(wormFlushed!);
        wormFlushed!.id = wormF.id;
      },
      onSuccess: () {
        onAddWormFlush(wormFlushed!);
        _wormFlushes.insert(0, wormFlushed!);
        _wormFlushes.refresh();
      },
      onFailure: (err) {
        printError(info: err.toString());
        _toastService.error(message: LocaleKeys.error.trans(), context: Get.context!);
      },
    );
  }

  void onAddWormFlush(PetWormFlushed petWormFlushed) {
    pet.petWormFlushes?.insert(0, petWormFlushed);
    if ((pet.petWormFlushes?.length ?? 0) > 2) pet.petWormFlushes?.removeLast();
    pet.notifyUpdate();
  }

  Future getWormFlushes() async {
    if (isLastPage) return;
    await call(
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

  WormFlushedWidgetModel(this._getWormFlushesUsecase, this._addWormFlushedUsecase, this._toastService);

  List<PetWormFlushed> get wormFlushes => _wormFlushes.toList();
}
