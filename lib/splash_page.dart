import 'dart:async';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/login/select_business.dart';
import 'package:fluttermarketingplus/login/select_role.dart';
import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant/global_data.dart';
import 'login/login_page.dart';
import 'navigator/special_home_page/pick_up_pages/washing_detail_pages/edit_address_page.dart';

//闪屏页
class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  SharedPreferences prefs;

  @override
  void initState() {
    countDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/splash_rect_bg.png',
            width: ScreenUtil().setWidth(669),
            fit: BoxFit.fitWidth,
          ),
          Container(
            child: Text(
              '全新小哥 为你而来',
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(32)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(30)),
            child: Text(
              '更智能 更便捷 做更懂你的小哥端',
              style: TextStyle(
                  color: Color(0xff8A8888), fontSize: ScreenUtil().setSp(25)),
            ),
          )
        ],
      ),
    ));
  }

  Future<bool> _initData() async {
    await AmapService.init(
      iosKey: '0af319a6285f8a3e3e73923c4840264d',
      androidKey: '802c19fe6406546a7d2addb7d31173d3',
    );
    await AmapCore.init('0af319a6285f8a3e3e73923c4840264d');
    await enableFluttifyLog(false); // 关闭log
    prefs = await SharedPreferences.getInstance();
    GlobalData.prefs = prefs;
    return true;
  }

// 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 1);
    Future.delayed(_duration, delayTime);
  }

  void delayTime() {
    _initData().then((val) {
      go2HomePage();
    });
  }

  void go2HomePage() {
    String _accessToken = GlobalData.prefs?.getString('accessToken') ?? '';
    if (_accessToken.isNotEmpty) {
      String _role = GlobalData.prefs.getString('role')??'小哥';
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) => LoginPage()),
          (route) => route == null);

//      Navigator.of(context).pushAndRemoveUntil(
//          new MaterialPageRoute(builder: (context) => EditAddressPage()),
//              (route) => route == null);
    } else {
      //跳转页面之后，销毁当前页面
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => route == null);

    }
  }
}
