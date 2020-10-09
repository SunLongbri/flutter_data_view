import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';

//包裹信息页面
class PackageInfoPage extends StatefulWidget {
  @override
  _PackageInfoPageState createState() => _PackageInfoPageState();
}

class _PackageInfoPageState extends State<PackageInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '包裹信息',
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: AutoLayout.instance.pxToDp(20),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Column(
          children: <Widget>[
            _packageInfoWidget(),
            _printBtn()
          ],
        ),
      ),
    );
  }

  //打印按钮
  Widget _printBtn() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        showToast('确认打印 ... ');
      },
      child: Container(
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(70),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(94),
            right: ScreenUtil().setWidth(94),
            top: AutoLayout.instance.pxToDp(122)),
        decoration: BoxDecoration(
            color: ColorConstant.blueBgColor,
            borderRadius: BorderRadius.circular(100)),
        child: Text(
          '确认打印',
          style:
              TextStyle(fontSize: ScreenUtil().setSp(32), color: Colors.white),
        ),
      ),
    );
  }

  //包裹信息组件
  Widget _packageInfoWidget() {
    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(36)),
              width: ScreenUtil().setWidth(238),
              child: Image.asset(
                'images/store_package_icon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(32)),
              child: Text(
                '打包成功',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: ColorConstant.blackTextColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: AutoLayout.instance.pxToDp(82),
                  bottom: AutoLayout.instance.pxToDp(138)),
              child: Column(
                children: <Widget>[
                  Text(
                    '上海工厂03 -沪三线-上海天山',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: ColorConstant.blackTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: AutoLayout.instance.pxToDp(20)),
                    child: Text(
                      '包裹编号：WASH23717752901',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: ColorConstant.blackTextColor),
                    ),
                  ),
                  Text(
                    '门店打包时间：2019/01/09 10',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: ColorConstant.blackTextColor),
                  ),
                  Text(
                    '衣物数量：25',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: ColorConstant.blackTextColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
