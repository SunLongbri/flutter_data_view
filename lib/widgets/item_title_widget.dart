import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';

//单行标题栏组件
class ItemTitleWidget extends StatelessWidget {
  @required
  final String title;

  //右侧组件的文字名称
  final String rightContent;
  final VoidCallback rightClickCallBack;
  final double marginTop;

  const ItemTitleWidget(this.title,
      {Key key,
      this.marginTop = 24,
      this.rightContent = '',
      this.rightClickCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(marginTop)),
      alignment: Alignment.centerLeft,
      height: AutoLayout.instance.pxToDp(78),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(18)),
                width: ScreenUtil().setWidth(10),
                height: AutoLayout.instance.pxToDp(32),
                color: ColorConstant.blueTextColor,
              ),
              Text(
                title,
                style: TextStyle(
                    color: ColorConstant.blackTextColor,
                    fontSize: ScreenUtil().setSp(30),
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          rightContent.isEmpty ? Container() : _rightWidget(rightContent)
        ],
      ),
    );
  }

  //右侧组件
  Widget _rightWidget(String rightContent) {
    return InkWell(
      onTap: rightClickCallBack,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        child: Row(
          children: [
            Text(
              rightContent,
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(24)),
            ),
            Container(
              width: ScreenUtil().setWidth(9),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(29)),
              height: AutoLayout.instance.pxToDp(17),
              child: Image.asset(
                'images/arrow.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
