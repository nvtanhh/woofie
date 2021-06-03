import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_worm_flushed_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_worm_flushes_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WormFlushedWidgetModel extends BaseViewModel {
  late int petId;
  late bool isMyPet;
  final RxList<PetWormFlushed> _wormFlushes = RxList<PetWormFlushed>();
  final GetWormFlushesUsecase _getWormFlushesUsecase;
  final AddWormFlushedUsecase _addWormFlushedUsecase;

  @override
  void initState() {
    _getWormFlushes();
    super.initState();
  }

  void showDialogAddWieght() {}
  Future _getWormFlushes() async {
    _wormFlushes.addAll(
      await _getWormFlushesUsecase.call(
        petId,
      ),
    );
  }

  WormFlushedWidgetModel(this._getWormFlushesUsecase, this._addWormFlushedUsecase);

  List<PetWormFlushed> get wormFlushes => _wormFlushes.toList();
}
