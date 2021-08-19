import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/not_have_data_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

// ignore: must_be_immutable
class WeightChartPreviewWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<PetWeight> weights;
  final bool isMyPet;
  late List<int> showIndexes = [];
  late List<FlSpot> allSpots = [];
  late LineChartBarData tooltipsOnBar;
  final Function onAddClick;

  WeightChartPreviewWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.weights,
    required this.isMyPet,
    required this.onAddClick,
  }) : super(key: key) {
    for (var i = 0; i < weights.length; i++) {
      showIndexes.add(i);
      allSpots.add(
        FlSpot(i.toDouble(), weights[weights.length - i - 1].weight ?? 0),
      );
    }
    tooltipsOnBar = LineChartBarData(
      showingIndicators: showIndexes,
      spots: allSpots,
      isCurved: true,
      barWidth: 3,
      shadow: const Shadow(blurRadius: 1, color: UIColor.primary),
      dotData: FlDotData(show: false),
      colors: [UIColor.primary],
      colorStops: [0.1, 0.4, 0.9],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [tooltipsOnBar];
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: UIColor.white,
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: UIColor.gray25, spreadRadius: 2),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Assets.resources.icons.icWeight.image(fit: BoxFit.fill, width: 24.w, height: 24.w),
              SizedBox(
                width: 5.w,
              ),
              Text(
                LocaleKeys.profile_weight.trans(),
                style: UITextStyle.text_header_14_w700,
              )
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          if (weights.isNotEmpty)
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: LineChart(
                  LineChartData(
                    showingTooltipIndicators: showIndexes.map((index) {
                      return ShowingTooltipIndicators([
                        LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar), tooltipsOnBar.spots[index]),
                      ]);
                    }).toList(),
                    lineTouchData: LineTouchData(
                      enabled: false,
                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(color: Colors.transparent),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                radius: 5,
                                color: UIColor.primary,
                                strokeWidth: 0.5,
                                strokeColor: UIColor.primary,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                          return lineBarsSpot.map((lineBarSpot) {
                            return LineTooltipItem(
                              "${lineBarSpot.y.toString()} Kg",
                              UITextStyle.text_body_10_w500,
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: lineBarsData,
                    minY: 0,
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                        showTitles: false,
                      ),
                      bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (val) {
                            return FormatHelper.formatDateTime(weights[val.toInt()].date, pattern: "MM/yyyy");
                          },
                          getTextStyles: (value) => UITextStyle.text_body_10_w500),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: false,
                    ),
                  ),
                ),
              ),
            )
          else
            NotHaveData(
              isMyPet: isMyPet,
              onAddClick: onAddClick,
            )
        ],
      ),
    );
  }
}
