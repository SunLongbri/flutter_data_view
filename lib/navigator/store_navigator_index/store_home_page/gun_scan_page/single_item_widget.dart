import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//单个扫码结果组件
class SingleItemWidget extends StatefulWidget {
  final VoidCallback onTap;

  const SingleItemWidget({Key key, this.onTap}) : super(key: key);

  @override
  _SingleItemWidgetState createState() => _SingleItemWidgetState();
}

class _SingleItemWidgetState extends State<SingleItemWidget> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Container(
        color: Colors.white,
        height: AutoLayout.instance.pxToDp(142),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(24), right: ScreenUtil().setWidth(44)),
        margin: EdgeInsets.only(
            top: AutoLayout.instance.pxToDp(18),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              width: ScreenUtil().setWidth(34),
              child: Image.asset(
                'images/item_code_icon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'A5565737A    针织衫/羊毛衫',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: ColorConstant.blackTextColor),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              width: ScreenUtil().setWidth(34),
              child: Image.asset(
                'images/select_icon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
