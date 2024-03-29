import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget_model.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/medical_actions_popup.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:timelines/timelines.dart';

class VaccinatedWidget extends StatefulWidget {
  final Pet pet;
  final bool isMyPet;
  final bool? addData;

  const VaccinatedWidget({
    super.key,
    required this.pet,
    this.addData,
    required this.isMyPet,
  });

  @override
  _VaccinatedWidgetState createState() => _VaccinatedWidgetState();
}

class _VaccinatedWidgetState
    extends BaseViewState<VaccinatedWidget, VaccinatedWidgetModel> {
  @override
  void loadArguments() {
    viewModel.pet = widget.pet;
    viewModel.isMyPet = widget.isMyPet;
    if (widget.addData == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) => viewModel.showDialogAddWeight());
    }
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocaleKeys.profile_vaccinated.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(),
          ),
          actions: [
            if (viewModel.isMyPet)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: MWButton(
                  onPressed: () => viewModel.showDialogAddWeight(),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  borderRadius: BorderRadius.circular(10.r),
                  minWidth: 50.w,
                  child: Text(
                    LocaleKeys.profile_add.trans(),
                    style: UITextStyle.white_12_w600,
                  ),
                ),
              )
          ],
          toolbarHeight: 55.h,
        ),
        body: Obx(
          () => Timeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0.25,
            ),
            builder: TimelineTileBuilder.connected(
              oppositeContentsBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Text(
                  FormatHelper.formatDateTime(viewModel.vaccinates[index].date,
                      pattern: "dd/MM/yyyy",),
                  style: UITextStyle.text_secondary_12_w500,
                ),
              ),
              itemExtent: 100.h,
              contentsBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.vaccinates[index].name ?? "",
                          style: UITextStyle.text_header_14_w600,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Flexible(
                          child: Text(
                            viewModel.vaccinates[index].description ?? "",
                            style: UITextStyle.text_secondary_12_w500,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.isMyPet)
                      Align(
                        alignment: Alignment.topRight,
                        child: MedicalActionsTrailing(
                          onEdit: () => viewModel.onEdit(
                              viewModel.vaccinates[index], index,),
                          onDelete: () => viewModel.onDelete(
                              viewModel.vaccinates[index], index,),
                        ),
                      )
                  ],
                ),
              ),
              connectorBuilder: (_, index, connectorType) {
                Color? color;
                if (index + 1 < viewModel.vaccinates.length - 1) {
                  color = UIColor.primary;
                } else {
                  viewModel.getVaccinates();
                }
                return SolidLineConnector(
                  indent: connectorType == ConnectorType.start ? 0 : 2.0,
                  endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
                  color: color ?? UIColor.primary,
                );
              },
              indicatorBuilder: (context, index) {
                if (index == viewModel.vaccinates.length - 1) {
                  viewModel.getVaccinates();
                }
                return OutlinedDotIndicator(
                  color: UIColor.primary,
                  borderWidth: 6,
                  size: 20.w,
                );
              },
              itemCount: viewModel.vaccinates.length,
            ),
          ),
        ),
      ),
    );
  }

  @override
  VaccinatedWidgetModel createViewModel() => injector<VaccinatedWidgetModel>();
}
