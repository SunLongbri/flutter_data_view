import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//条码信息
class CodeInfoWidget extends StatelessWidget {
  final String goodsCode;
  final String goodsName;

  const CodeInfoWidget({Key key, this.goodsCode, this.goodsName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AutoLayout.instance.pxToDp(206),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(20)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: <Widget>[_titleWidget(), Expanded(child: _contentWidget())],
      ),
    );
  }

  Widget _contentWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleRowWidget('商品品类', goodsName),
          _singleRowWidget('条码信息', goodsCode),
        ],
      ),
    );
  }

  Widget _singleRowWidget(String title, String content) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${title}: ',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: ColorConstant.greyTextColor),
          ),
          Text(
            content,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: ColorConstant.blackTextColor),
          )
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(78),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: ColorConstant.greyLineColor,
      ))),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(6),
            height: AutoLayout.instance.pxToDp(28),
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(7)),
            child: Text(
              '条码信息',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
