import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String leadingImg;
  final Color bgColor;
  final double titleSize;
  final String title;
  final Widget actionsWidget;
  final VoidCallback actionPress;
  final VoidCallback backPress;
  final bool showBack;

  const AppBarWidget({
    Key key,
    this.leadingImg = 'images/login_back.png',
    this.bgColor = ColorConstant.primaryColor,
    this.titleSize = 36,
    this.title = '标题',
    this.actionsWidget,
    this.actionPress,
    this.backPress,
    this.showBack = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.dark,//白色文字
      backgroundColor: bgColor,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(titleSize),
            fontWeight: FontWeight.w500),
      ),
      leading: showBack
          ? InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: backPress != null
            ? backPress
            : () {
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            leadingImg,
            width: ScreenUtil().setWidth(21),
            height: AutoLayout.instance.pxToDp(33),
            fit: BoxFit.fitHeight,
          ),
        ),
      )
          : Container(),
      centerTitle: true,
      actions: <Widget>[
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: actionPress,
          child: Container(
            alignment: Alignment.center,
            height: ScreenUtil().setHeight(45),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            child: actionsWidget == null ? Container() : actionsWidget,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.0);
}
