import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//首页弹窗
class HomeDialog extends StatefulWidget {
  @override
  _HomeDialogState createState() => _HomeDialogState();
}

class _HomeDialogState extends State<HomeDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(830),
          width: ScreenUtil().setHeight(734),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/popup.png',
                ),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(103)),
                child: Text(
                  '消息提醒',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(50)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(266)),
                width: ScreenUtil().setWidth(297),
                child: Text(
                  '昨日步行全国排行第一昨日订单额全国第三昨日业绩提成800元',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(54)),
                child: Text(
                  '再接再厉哦~~',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(9)),
          child: IconButton(
            icon: Image.asset(
              'images/cancel.png',fit: BoxFit.fitWidth,
              width: ScreenUtil().setWidth(78),
            ),
            onPressed: () {
              go2HomePage();
            },
          ),
        )
      ],
    );
  }



  void go2HomePage() {
    //跳转页面之后，销毁当前页面
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => route == null);
  }
}
