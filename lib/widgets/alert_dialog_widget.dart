import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertDialogWidget {
  String title;
  String leftBtn;
  String rightBtn;
  bool showCancel;//true 显示取消按钮，false：去掉取消按钮

  AlertDialogWidget(
      {this.title = '标题',
      this.leftBtn = '取消',
      this.rightBtn = '确定',
      this.showCancel = false});

  Future<String> show(BuildContext context) async {
    List<Widget> listWidget = [];
    if (showCancel) {
      listWidget.add(CupertinoDialogAction(
        child: Text(leftBtn),
        onPressed: () {
          Navigator.pop(context, '取消');
        },
      ));
    }
    listWidget.add(
      CupertinoDialogAction(
        child: Text(rightBtn),
        onPressed: () {
          Navigator.pop(context, '确定');
        },
      ),
    );
    return await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(35)),
            ),
            actions: listWidget,
          );
        });
  }
}
