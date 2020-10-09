import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/select_role.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/search_page.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMulti = GlobalData.prefs.getBool('isMulti');
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(60)),
      child: Row(
        children: <Widget>[
          //切换角色
//          isMulti ? _backBtnWidget(context) : Container(),
          Expanded(child: _searchBarWidget(context))
        ],
      ),
    );
  }

  //返回按钮
  Widget _backBtnWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: ScreenUtil().setWidth(82),
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(76),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Color(0x30022C42), blurRadius: 20),
            ]),
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(16),
        ),
        child: Image.asset(
          'images/switch_user.png',
          width: ScreenUtil().setWidth(24),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  //搜索条组件
  Widget _searchBarWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SearchPage()));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(76),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Color(0x30022C42), blurRadius: 20),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  width: ScreenUtil().setWidth(44),
                  child: Image.asset('images/home_search.png'),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  child: Text(
                    '订单号/商品条码/客户手机号',
                    style: TextStyle(
                        color: ColorConstant.hintTextColor,
                        fontSize: ScreenUtil().setSp(32),
                        fontFamily: 'PingFang'),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
              width: ScreenUtil().setWidth(44),
              child: Image.asset('images/home_scan.png'),
            ),
          ],
        ),
      ),
    );
  }
}
