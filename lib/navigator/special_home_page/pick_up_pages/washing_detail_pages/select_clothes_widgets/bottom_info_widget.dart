import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../confirm_order_page.dart';

//底部商品信息组件
class BottomInfoWidget extends StatefulWidget {
  @override
  _BottomInfoWidgetState createState() => _BottomInfoWidgetState();
}

class _BottomInfoWidgetState extends State<BottomInfoWidget> {
  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    DataProvider _dataProvider = Provider.of<DataProvider>(context);
    Map<String, int> _tempCountMap = _dataProvider.getTempCountMap;
    totalCount = 0;
    _tempCountMap.forEach((key, value) {
      print('key:${key},value:${value}');
      totalCount = totalCount + value;
    });
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(22), right: ScreenUtil().setWidth(38)),
      height: AutoLayout.instance.pxToDp(100),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xff3FCDFF)))),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(64),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(12)),
            child: Stack(
              children: <Widget>[
                Image.asset('images/bottom_markets_icon.png'),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(7),
                          right: ScreenUtil().setWidth(7)),
                      decoration: BoxDecoration(
                          color: ColorConstant.redBgColor,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Text(
                        totalCount.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28)),
                      )),
                )
              ],
            ),
          ),
          Container(
            child: Text(
              '总金额: ¥${_dataProvider.getTotalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(34)),
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(220),
            child: FlatButton(
                color: ColorConstant.blueBgColor,
                splashColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  if(totalCount == 0){
                    showToast('请先选择衣物！');
                    return;
                  }
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ConfirmOrderPage()));

                },
                child: Text(
                  '确认下单',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(30)),
                )),
          ))
        ],
      ),
    );
  }
}
