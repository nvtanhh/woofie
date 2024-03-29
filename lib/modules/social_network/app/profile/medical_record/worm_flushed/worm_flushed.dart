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
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/medical_actions_popup.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed_model.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:timelines/timelines.dart';

class WormFlushedWidget extends StatefulWidget {
  final Pet pet;
  final bool isMyPet;
  final bool? addData;

  const WormFlushedWidget({
    super.key,
    required this.pet,
    required this.isMyPet,
    this.addData,
  });

  @override
  _WormFlushedWidgetState createState() => _WormFlushedWidgetState();
}

class _WormFlushedWidgetState
    extends BaseViewState<WormFlushedWidget, WormFlushedWidgetModel> {
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
            LocaleKeys.profile_worm_flush.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(),
          ),
          actions: [
            if (viewModel.isMyPet)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: MWButton(
                  onPressed: () => viewModel.showDialogAddWeight(),
                  minWidth: 50.w,
                  borderRadius: BorderRadius.circular(10.r),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
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
              nodePosition: 0,
              color: UIColor.aquaSpring,
              connectorTheme: const ConnectorThemeData(
                thickness: 3.0,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            builder: TimelineTileBuilder.connected(
              indicatorBuilder: (context, index) {
                if (index == viewModel.wormFlushes.length - 1) {
                  viewModel.getWormFlushes();
                }
                return OutlinedDotIndicator(
                  color: UIColor.primary,
                  borderWidth: 5,
                  size: 20.w,
                );
              },
              connectorBuilder: (_, index, connectorType) {
                Color? color;
                if (index + 1 < viewModel.wormFlushes.length - 1) {
                  color = UIColor.primary;
                }
                return SolidLineConnector(
                  indent: connectorType == ConnectorType.start ? 0 : 2.0,
                  endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
                  color: color ?? UIColor.primary,
                );
              },
              contentsBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          FormatHelper.formatDateTime(
                            viewModel.wormFlushes[index].date,
                            pattern: "dd/MM/yyyy",
                          ),
                          style: UITextStyle.text_header_14_w600,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Flexible(
                          child: Text(
                            viewModel.wormFlushes[index].description ?? "",
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
                              viewModel.wormFlushes[index], index,),
                          onDelete: () => viewModel.onDelete(
                              viewModel.wormFlushes[index], index,),
                        ),
                      )
                  ],
                ),
              ),
              itemExtentBuilder: (_, index) {
                return 100.h;
              },
              itemCount: viewModel.wormFlushes.length,
            ),
          ),
        ),
      ),
    );
  }

  @override
  WormFlushedWidgetModel createViewModel() =>
      injector<WormFlushedWidgetModel>();
}
