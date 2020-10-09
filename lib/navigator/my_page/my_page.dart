import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';

//我的页面
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //用户名
  String _userName;
  List<String> _menuList;

  @override
  void initState() {
    _userName = GlobalData.prefs.getString('user_name') ?? '';
    _menuList = GlobalData.prefs.getStringList('menuStrList') ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _topWidget(),
          _menuList.contains('网点管理报表')
              ? _singleItemWidget('images/me_report.png', '网点管理报表')
              : Container(),
          _menuList.contains('我的客户')
              ? _singleItemWidget(
                  'images/me_customer.png',
                  '我的客户',
                  showBottomLine: true,
                )
              : Container(),
          _menuList.contains('我的佣金')
              ? _singleItemWidget('images/me_commission.png', '我的佣金',
                  showBottomLine: true)
              : Container(),
          _menuList.contains('小哥报表')
              ? _singleItemWidget('images/report_deliver_icon.png', '小哥报表')
              : Container(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            bottom: AutoLayout.instance.pxToDp(40),
            left: ScreenUtil().setWidth(200),
            right: ScreenUtil().setWidth(200)),
        child: FlatButton(
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.blue,
          onPressed: () {
            AlertDialogWidget(title: '确定退出登录?', showCancel: true)
                .show(context)
                .then((val) {
              if (val.contains('确定')) {
                GlobalData.prefs.setString('user_role', '');
                GlobalData.prefs.setString('user_name', '');
                GlobalData.prefs.setString('accessToken', '');
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => route == null);
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Text(
              '退出登陆',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //单行选项列表组件
  Widget _singleItemWidget(String iconImgAssets, String content,
      {double marginTop = 0, bool showBottomLine = false}) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (content.compareTo('网点管理报表') == 0) {
          JumpReceive().jump(context, Routes.dotManagePage);
        } else if (content.compareTo('我的客户') == 0) {
          JumpReceive().jump(context, Routes.myConsumerPage,
              paramsName: 'titledata', sendData: '门店客户');
        } else if (content.compareTo('我的佣金') == 0) {
          JumpReceive().jump(context, Routes.myCommissionPage);
        } else if (content.compareTo('小哥报表') == 0) {
          JumpReceive().jump(context, Routes.showReportPage);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(marginTop)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(23), right: ScreenUtil().setWidth(11)),
        height: AutoLayout.instance.pxToDp(80),
        decoration: BoxDecoration(
            color: Colors.white,
            border: showBottomLine
                ? Border(bottom: BorderSide(color: ColorConstant.greyLineColor))
                : Border()),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(44),
              child: Image.asset(
                iconImgAssets,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
                child: Container(
              child: Text(
                content,
                style: TextStyle(
                    color: ColorConstant.blackTextColor,
                    fontSize: ScreenUtil().setSp(28)),
              ),
            )),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(28)),
              width: ScreenUtil().setWidth(9),
              child: Image.asset(
                'images/arrow_more.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //顶部头像组件
  Widget _topWidget() {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(374),
      child: Stack(
        children: <Widget>[
          _myQRBgWidget(),
//          _myBackWidget(),
          _myQRHeadImgWidget(),
          _myQRWidget(),
        ],
      ),
    );
  }

  //我的页面，用户头像
  Widget _myQRHeadImgWidget() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(150),
            child: Image.asset(
              'images/login_head.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(23)),
            child: Text(
              _userName,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(30)),
            ),
          )
        ],
      ),
    );
  }

  //我的页面顶部背景图片
  Widget _myQRBgWidget() {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(374),
      child: Image.asset(
        'images/me_top_bg.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  //我的返回按钮
  Widget _myBackWidget() {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(74),
              left: ScreenUtil().setWidth(28)),
          width: ScreenUtil().setWidth(22),
          child: Image.asset(
            'images/login_back.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  //我的二维码组件
  Widget _myQRWidget() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          JumpReceive().jump(context, Routes.myCanvasPage,
              paramsName: 'titledata', sendData: '我的二维码');
        },
        child: Container(
          margin: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(74),
              right: ScreenUtil().setWidth(28)),
          width: ScreenUtil().setWidth(44),
          child: Image.asset(
            'images/me_qr_code.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
