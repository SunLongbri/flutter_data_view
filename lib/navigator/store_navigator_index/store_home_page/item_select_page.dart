import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/navigator/store_navigator_index/store_home_page/gun_scan_page.dart';
import 'package:fluttermarketingplus/navigator/store_navigator_index/store_home_page/phone_scan_page.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_action_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';

//条目选择页面
class ItemSelectPage extends StatefulWidget {
  @override
  _ItemSelectPageState createState() => _ItemSelectPageState();
}

class _ItemSelectPageState extends State<ItemSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '洗前-出库打包',
      ),
      body: Column(
        children: <Widget>[
          _singleItemWidget(),
        ],
      ),
    );
  }

  //单个条目组件
  Widget _singleItemWidget() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        BottomActionWidget(topTitle: '请选择扫码工具', itemList: ['手机扫码', '扫码枪扫码'])
            .show(context)
            .then((value) {
          print('value:${value}');
          if (value == '手机扫码') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PhoneScanPage()));
          } else if (value == '扫码枪扫码') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GunScanPage()));
          }
        });
      },
      child: Container(
        height: AutoLayout.instance.pxToDp(100),
        color: Colors.white,
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(22),
            right: ScreenUtil().setWidth(22),
            top: AutoLayout.instance.pxToDp(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
              child: Text(
                '出库打包',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Colors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              height: AutoLayout.instance.pxToDp(30),
              child: Image.asset(
                'images/arrow_grey_right.png',
                fit: BoxFit.fitHeight,
              ),
            )
          ],
        ),
      ),
    );
  }
}
