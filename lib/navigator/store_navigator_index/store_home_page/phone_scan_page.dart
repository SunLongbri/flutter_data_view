import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/navigator/store_navigator_index/store_home_page/gun_scan_page/single_item_widget.dart';
import 'package:fluttermarketingplus/navigator/store_navigator_index/store_home_page/package_info_page.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';

//手机扫码页面
class PhoneScanPage extends StatefulWidget {
  @override
  _PhoneScanPageState createState() => _PhoneScanPageState();
}

class _PhoneScanPageState extends State<PhoneScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '出库打包',
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int position) {
              return SingleItemWidget();
            }),
      ),
      bottomNavigationBar: _bottomFunWidget(),
    );
  }

  //底部功能组件
  Widget _bottomFunWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(142),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: FractionalOffset(0, 1),
            child: Container(
              height: AutoLayout.instance.pxToDp(94),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  _selectAllBtn(),
                  _totalCountWidget(),
                  Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => PackageInfoPage()));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: ColorConstant.blueTextColor,
                            width: ScreenUtil().setWidth(266),
                            child: Text(
                              '系统生成包裹',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(32), color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap:(){
                showToast('点击了扫码按钮 .... ');
              },
              child: Container(
                width: ScreenUtil().setWidth(114),
                child: Image.asset('images/menu_scan.png',fit: BoxFit.fitWidth,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //总计组件
  Widget _totalCountWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
      child: Text(
        '合计：20件',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(34),
            color: ColorConstant.blackTextColor),
      ),
    );
  }

  //全选按钮
  Widget _selectAllBtn() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        showToast('全选');
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  right: ScreenUtil().setWidth(10),
                  left: ScreenUtil().setWidth(20)),
              width: ScreenUtil().setWidth(40),
              child: Image.asset(
                'images/select_icon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              '全选',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: ColorConstant.blueTextColor),
            )
          ],
        ),
      ),
    );
  }
}
