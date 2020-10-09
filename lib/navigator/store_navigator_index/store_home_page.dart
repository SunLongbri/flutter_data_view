import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';

import 'store_home_page/item_select_page.dart';

//门店首页
class StoreHomePage extends StatefulWidget {
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '泰笛洗涤',
        showBack: false,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _topImageWidget(),
            _firstFunWidget(),
            _secondFunWidget(),
            _textWidget(),
          ],
        ),
      ),
    );
  }
  
  //功能文字组件
  Widget _textWidget(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(16),right: ScreenUtil().setWidth(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleTextWidget('全部订单'),
          _singleTextWidget('工厂未签收'),
          _singleTextWidget('门店已签收'),
          _singleTextWidget('门店未签收'),
        ],
      ),
    );
  }
  
  //单个文字组件
  Widget _singleTextWidget(String funText){
    return Container(
      child: Text(funText,style: TextStyle(fontSize: ScreenUtil().setSp(28),color: ColorConstant.blackTextColor),),
    );
  }

  //第二行功能栏
  Widget _secondFunWidget(){
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(16),right: ScreenUtil().setWidth(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleFuncWidget('images/store_home_3.png'),
          _singleFuncWidget('images/store_home_4.png'),
          _singleFuncWidget('images/store_home_5.png'),
          _singleFuncWidget('images/store_home_6.png'),
        ],
      ),
    );
  }

  //第一行功能栏
  Widget _firstFunWidget(){
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(16),left: ScreenUtil().setWidth(16),right: ScreenUtil().setWidth(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleFuncWidget('images/store_home_1.png'),
          _singleFuncWidget('images/store_home_2.png'),
        ],
      ),
    );
  }

  //单个功能组件
  Widget _singleFuncWidget(String imageAssets){
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap:(){
        //门店到干线
        if(imageAssets.contains('1')){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ItemSelectPage()));
        }
      },
      child: Container(
        height: AutoLayout.instance.pxToDp(172),
        child: Image.asset(imageAssets,fit: BoxFit.fitWidth,),
      ),
    );
  }
  
  //顶部图片组件
  Widget _topImageWidget(){
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750),
      height: AutoLayout.instance.pxToDp(404),
      child: Image.asset('images/store_home_top.png',fit: BoxFit.fill,),
    );
  }
}
