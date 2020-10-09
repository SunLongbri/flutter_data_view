import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//全部订单 - 订单内容 - 单行样式组件
class SingleLineWidget extends StatelessWidget {
  String orderState;
  String orderCount;
  VoidCallback callback;

  SingleLineWidget(
      {Key key, this.orderState, this.orderCount, this.callback})
      : super(key: key);

  Color _countTextColor;
  Color _countBgColor;

  @override
  Widget build(BuildContext context) {
    if(orderState == '未受理'){
      _countTextColor = ColorConstant.redTextColor;
      _countBgColor = ColorConstant.redBgLightColor;
    }else if(orderState == '已受理'){
      _countTextColor = ColorConstant.yellowTextColor;
      _countBgColor = ColorConstant.yellowBgColor;
    }else if(orderState == '派送中'){
      _countTextColor = ColorConstant.blueTextColor;
      _countBgColor = ColorConstant.blueBgLightColor;
    }else{
      _countTextColor = ColorConstant.blackTextColor;
      _countBgColor = Colors.transparent;
    }
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: callback,
      child: Container(
        color: Colors.white,
        height: AutoLayout.instance.pxToDp(80),
        margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(20)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              orderState,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(28),
                  fontFamily: 'PingFang',
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(10)),
                  decoration: BoxDecoration(
                      color: _countBgColor,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  height: ScreenUtil().setWidth(44),
                  child: Text(
                    orderCount,
                    style: TextStyle(
                        color: _countTextColor,
                        fontSize: ScreenUtil().setSp(25)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(34)),
                  width: ScreenUtil().setWidth(14),
                  child: Image.asset(
                    'images/arrow_grey_right.png',
                    fit: BoxFit.fitWidth,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
