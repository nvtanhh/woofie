import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_worm_flushed_dialog.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_worm_flushed_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_worm_flushes_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:meowoof/locale_keys.g.dart';
@injectable
class WormFlushedWidgetModel extends BaseViewModel {
  late int petId;
  late bool isMyPet;
  final RxList<PetWormFlushed> _wormFlushes = RxList<PetWormFlushed>();
  final GetWormFlushesUsecase _getWormFlushesUsecase;
  final AddWormFlushedUsecase _addWormFlushedUsecase;
  final ToastService _toastService;

  @override
  void initState() {
    getWormFlushes();
    super.initState();
  }

  Future showDialogAddWeight() async {
    final PetWormFlushed? wormFlushes = await Get.dialog(
      AddWormFlushedDialog(),
    );
    if (wormFlushes == null) {
      return;
    }
    await call(
      () async => _addWormFlushedUsecase.call(wormFlushes),
      onSuccess: () {
        _wormFlushes.insert(0, wormFlushes);
        _wormFlushes.refresh();
      },
      onFailure: (err) {
        // _toastService.error(message: LocaleKeys., context: Get.context!);
      },
    );
  }

  Future getWormFlushes() async {
    _wormFlushes.addAll(
      await _getWormFlushesUsecase.call(
        petId,
        offset: _wormFlushes.length,
      ),
    );
  }

  WormFlushedWidgetModel(this._getWormFlushesUsecase, this._addWormFlushedUsecase, this._toastService);

  List<PetWormFlushed> get wormFlushes => _wormFlushes.toList();
}
