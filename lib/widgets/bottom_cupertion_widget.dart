//底部弹出选择器
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:vibration/vibration.dart';

class BottomCupertionWidget {
  List<String> listContent;
  int itemPosition = 0;
  String centerTitle;
  List<Widget> listWidget = [];

  BottomCupertionWidget({this.listContent, this.centerTitle = ' '});

  Future<String> selectData(BuildContext context) async {
    if (listContent == null) {
      listContent = ['条目一', '条目二', '条目三', '条目四'];
      centerTitle = ' ';
    }
    listContent.forEach((item) {
      listWidget.add(_singleWidget(item));
    });
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          width: ScreenUtil().setWidth(750),
          height: AutoLayout.instance.pxToDp(500),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xffF2F2F2), width: 0.5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _bottomBtn(context, '取消'),
                    _bottomBtn(context, centerTitle),
                    _bottomBtn(context, '确定'),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(35),
                    right: ScreenUtil().setWidth(35)),
                child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 40,
                    useMagnifier: true,
                    onSelectedItemChanged: (position) async {
                      //检查是否支持振动
//                      if (await Vibration.hasVibrator()) {
//                        Vibration.vibrate();
//                      }
//                      if (await Vibration.hasAmplitudeControl()) {
//                        Vibration.vibrate(amplitude: 10);
//                      }
                      itemPosition = position;
                      return listContent[itemPosition].toString();
                    },
                    children: listWidget),
              ))
            ],
          ),
        );
      },
    );
  }

  Widget _bottomBtn(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        if (text.contains('取消')) {
          Navigator.pop(context);
        } else if (text.contains('确定')) {
          Navigator.pop(context, listContent[itemPosition].toString());
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(90),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(10), right: ScreenUtil().setWidth(10)),
        child: Text(
          text,
          style: TextStyle(
              color: text == '取消' ? Colors.black : Colors.blue,
              fontSize: text == centerTitle
                  ? ScreenUtil().setSp(40)
                  : ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  Widget _singleWidget(String content) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        content,
        style: TextStyle(fontSize: ScreenUtil().setSp(35)),
      ),
    );
  }
}
