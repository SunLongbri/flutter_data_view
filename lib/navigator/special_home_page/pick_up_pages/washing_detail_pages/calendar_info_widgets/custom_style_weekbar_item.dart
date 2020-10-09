import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/widget/base_week_bar.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = [
    "日",
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
  ];

  @override
  Widget getWeekBarItem(int index) {
    return Container(
      height: AutoLayout.instance.pxToDp(64),
      color: ColorConstant.blueBgColor,
      child: Center(
        child: Text(
          weekList[index],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}