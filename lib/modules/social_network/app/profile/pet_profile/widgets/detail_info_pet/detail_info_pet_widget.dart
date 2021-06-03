import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/widgets/card_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/vaccinated_preview_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/weight_chart_preview_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/worm_flushed_preview_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_detail_info_pet_usecase.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class DetailInfoPetWidget extends StatefulWidget {
  final Pet pet;
  final bool isMyPet;
  final Function onAddWeightClick;
  final Function onAddWormFlushedClick;
  final Function onAddVaccinatedClick;

  const DetailInfoPetWidget({
    Key? key,
    required this.pet,
    required this.isMyPet,
    required this.onAddWeightClick,
    required this.onAddWormFlushedClick,
    required this.onAddVaccinatedClick,
  }) : super(key: key);

  @override
  _DetailInfoPetWidgetState createState() => _DetailInfoPetWidgetState();
}

class _DetailInfoPetWidgetState extends State<DetailInfoPetWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _isLoaded.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardDetailWidget(
                      title: LocaleKeys.explore_gender.trans(),
                      value: pet.gender?.toString() ?? "",
                    ),
                    CardDetailWidget(
                      title: LocaleKeys.explore_age.trans(),
                      value: DateTimeHelper.calcAge(pet.dob),
                    ),
                    CardDetailWidget(
                      title: LocaleKeys.explore_breed.trans(),
                      value: pet.petBreed?.name ?? "",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  LocaleKeys.profile_medical_record.trans(),
                  style: UITextStyle.text_header_18_w600,
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () => Get.to(
                    () => Weight(pet: pet, isMyPet: isMyPet),
                  ),
                  child: WeightChartPreviewWidget(
                    width: Get.width,
                    height: 175.h,
                    isMyPet: isMyPet,
                    onAddClick: isMyPet ? onAddWeightClick : () => null,
                    weights: [
                      PetWeight(
                        id: 0,
                        createdAt: DateTime.now().subtract(Duration(days: 3)),
                        weight: 2,
                      ),
                      PetWeight(
                        id: 1,
                        createdAt: DateTime.now().subtract(Duration(days: 2)),
                        weight: 3,
                      ),
                      PetWeight(
                        id: 2,
                        createdAt: DateTime.now().subtract(Duration(days: 1)),
                        weight: 2,
                      ),
                      PetWeight(
                        id: 3,
                        createdAt: DateTime.now(),
                        weight: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.to(
                          () => WormFlushedWidget(
                            petId: pet.id!,
                          ),
                        ),
                        child: WormFlushedPreviewWidget(
                          width: 160.w,
                          height: 188.h,
                          wormFlushed: [
                            PetWormFlushed(
                              id: 1,
                              createdAt: DateTime.now(),
                              description: "asdlad",
                            ),
                            PetWormFlushed(
                              id: 2,
                              createdAt: DateTime.now(),
                              description: "asccasc",
                            ),
                          ],
                          isMyPet: isMyPet,
                          onAddClick: isMyPet ? onAddWormFlushedClick : () => null,
                        ),
                      ),
                      VaccinatedPreviewWidget(
                        width: 160.w,
                        height: 188.h,
                        vaccinates: [
                          PetVaccinated(
                            id: 1,
                            createdAt: DateTime.now(),
                            description: "acb",
                          ),
                          PetVaccinated(
                            id: 2,
                            createdAt: DateTime.now(),
                            description: "aacccb",
                          ),
                        ],
                        isMyPet: isMyPet,
                        onAddClick: isMyPet ? onAddVaccinatedClick : () => null,
                      ),
                    ],
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class DetailInfoPetWidget extends StatelessWidget {
  final RxBool _isLoaded = RxBool(false);
  final GetDetailInfoPetUsecase _getDetailInfoPetUsecase = injector<GetDetailInfoPetUsecase>();

  DetailInfoPetWidget({
    Key? key,
    required this.pet,
    required this.isMyPet,
    required this.onAddWeightClick,
    required this.onAddWormFlushedClick,
    required this.onAddVaccinatedClick,
  }) : super(key: key) {
    _loadPetDetailInfo();
  }

  Future _loadPetDetailInfo() async {
    try {
      pet = await _getDetailInfoPetUsecase.call(pet.id!);
      _isLoaded.value = true;
    } catch (e) {
      printError(info: e.toString());
      _isLoaded.value = false;
    }
  }
}
