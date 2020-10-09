import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//任务量颜色显示组件
class TaskInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleColorInfo(Color(0xff41CAAB), '预约订单0~10单'),
          _singleColorInfo(Color(0xffF0B24C), '预约订单11~30单'),
          _singleColorInfo(Color(0xffFA6060), '预约订单大于30单'),
        ],
      ),
    );
  }

  Widget _singleColorInfo(Color textColor, String content) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(29),
            height: AutoLayout.instance.pxToDp(28),
            color: textColor,
          ),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
              child: Text(
                content,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(22),
                    color: ColorConstant.greyTextColor),
              ))
        ],
      ),
    );
  }
}
