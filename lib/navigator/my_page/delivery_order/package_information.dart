import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageInformation extends StatelessWidget {
  final String packageInformation;
  PackageInformation({this.packageInformation});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(width: 750,height: 1334);
    var _packageInformation = json.decode(JumpReceive().receive(packageInformation));
    return Scaffold(
      appBar: AppBarWidget(
        title: '包裹信息',
      ),
      body: Container(
        alignment: AlignmentDirectional.topCenter,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Container(
              width: ScreenUtil().setWidth(300),
              height: AutoLayout.instance.pxToDp(300),
              child: Image.asset('images/司机0.png',fit: BoxFit.fill,),
            ),
            SizedBox(height: 20,),
            Container(
              width: ScreenUtil().setWidth(300),
              alignment: AlignmentDirectional.topCenter,
              child: Text(_packageInformation['storeName'],style: TextStyle(fontSize: ScreenUtil().setSp(34),fontWeight: FontWeight.w700),),
            ),
            SizedBox(height: 10,),
            Container(
              width: ScreenUtil().setWidth(400),
              alignment: AlignmentDirectional.centerStart,
              child: Text('包裹编号:'+_packageInformation['packageNumber'],style: TextStyle(fontSize: ScreenUtil().setSp(24),fontWeight: FontWeight.w300),),
            ),
            SizedBox(height: 20,),
            Container(
              width: ScreenUtil().setWidth(400),
              alignment: AlignmentDirectional.centerStart,
              child: Text('门店打包时间:'+_packageInformation['createdate'],style: TextStyle(fontSize: ScreenUtil().setSp(24),fontWeight: FontWeight.w300),),
            ),
            SizedBox(height: 20,),
            Container(
              width: ScreenUtil().setWidth(400),
              alignment: AlignmentDirectional.centerStart,
              child: Text('衣物数量:'+_packageInformation['count'],style: TextStyle(fontSize: ScreenUtil().setSp(24),fontWeight: FontWeight.w300),),
            ),
            SizedBox(height: 5,),
            Container(
              width: ScreenUtil().setWidth(400),
              alignment: AlignmentDirectional.centerStart,
              child: Text('配件数量:'+_packageInformation['attachment_count'],style: TextStyle(fontSize: ScreenUtil().setSp(24),fontWeight: FontWeight.w300),),
            ),
          ],
        )
      ),
    );
  }
}