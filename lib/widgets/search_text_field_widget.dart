import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final ValueChanged<String> onSubmitted;
  final VoidCallback onTab;
  final String hintText;
  final EdgeInsetsGeometry margin;

  SearchTextFieldWidget(
      {Key key, this.hintText, this.onSubmitted, this.onTab, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: margin == null ? EdgeInsets.all(0.0) : margin,
      width: ScreenUtil().setWidth(615),
      height: ScreenUtil().setHeight(70),
      decoration: BoxDecoration(
          color: ColorConstant.greyBgColor,
          borderRadius: BorderRadius.circular(5.0)),
      child: TextField(
        onSubmitted: onSubmitted,
        onTap: onTab,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              color: ColorConstant.greyBgColor),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
          ),
        ),
        style: TextStyle(
          fontSize: ScreenUtil().setSp(24),
        ),
      ),
    );
  }
}
