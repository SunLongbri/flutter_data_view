import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/navigator/store_navigator_index/store_home_page/package_info_page.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';
import 'gun_scan_page/single_item_widget.dart';
import 'gun_scan_widgets/gun_bar_widget.dart';

//扫码枪扫码页面
class GunScanPage extends StatefulWidget {
  @override
  _GunScanPageState createState() => _GunScanPageState();
}

class _GunScanPageState extends State<GunScanPage> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          GunBarWidget(
            textEditingController: _textEditingController,
            onTap: () {
              showToast('搜索内容为:${_textEditingController.text.trim()}');
            },
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int position) {
                    return SingleItemWidget();
                  }))
        ],
      ),
      bottomNavigationBar: _bottomFunWidget(),
    );
  }

  //底部功能组件
  Widget _bottomFunWidget(){
    return Container(
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
                  onTap:(){
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
    );
  }

  //总计组件
  Widget _totalCountWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(34)),
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
