import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//扫码枪标题栏
class GunBarWidget extends StatelessWidget{

  final VoidCallback onTap;
  final TextEditingController textEditingController;

  const GunBarWidget({Key key, this.onTap,this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.blueBgColor,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(60)),
      child: Row(
        children: <Widget>[
          _backBtnWidget(context),
          Expanded(child: _searchBarWidget(context)),
          _searchBtn()
        ],
      ),
    );
  }

  Widget _searchBtn() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
        child: Text(
          '搜索',
          style:
          TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  //返回按钮
  Widget _backBtnWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: ScreenUtil().setWidth(76),
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(76),
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(16),
        ),
        child: Image.asset(
          'images/login_back.png',
          width: ScreenUtil().setWidth(24),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  //搜索条组件
  Widget _searchBarWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: AutoLayout.instance.pxToDp(60), maxWidth: 200),
      child: TextField(
        cursorColor: Color(0xffADADAD),
        controller: textEditingController,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(28)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: '请输入搜索内容',
          hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(28), color: Color(0xffADADAD)),
          prefixIcon: Container(
            padding: EdgeInsets.only(
                top: AutoLayout.instance.pxToDp(12),
                bottom: AutoLayout.instance.pxToDp(12)),
            child: Image.asset(
              'images/home_search.png',
              fit: BoxFit.contain,
            ),
          ),
          // contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}