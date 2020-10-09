import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/search_by_phone_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_page.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';

//顶部搜索栏
class SearchBarWidget extends StatefulWidget {
  final VoidStringCallback block;

  const SearchBarWidget({Key key, this.block}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController _codeController;

  @override
  void initState() {
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AutoLayout.instance.pxToDp(150),
      color: ColorConstant.primaryColor,
      padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(40)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _leadingBackWidget(),
          _titleWidget(),
          _actionWidget()
        ],
      ),
    );
  }

  Widget _leadingBackWidget() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(32), right: ScreenUtil().setWidth(18)),
        child: Image.asset(
          'images/login_back.png',
          width: ScreenUtil().setWidth(26),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        JumpReceive()
            .jump(context, Routes.deliveryOrderScanQrPage)
            .then((value) {
          print('value:${value}');
          setState(() {
            _codeController.text = value;
            widget.block('A${value.trim()}A');
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(28), right: ScreenUtil().setWidth(38)),
        child: Image.asset(
          'images/search_scan_icon.png',
          width: ScreenUtil().setWidth(36),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Expanded(
        child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: AutoLayout.instance.pxToDp(60)),
      child: TextField(
        controller: _codeController,
        textInputAction: TextInputAction.search,
        onSubmitted: (val) {
          widget.block(val.trim());
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: '订单号/商品条码/手机号',
          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(28)),
          prefixIcon: Container(
            padding: EdgeInsets.only(
                top: AutoLayout.instance.pxToDp(12),
                bottom: AutoLayout.instance.pxToDp(12)),
            width: ScreenUtil().setWidth(36),
            child: Image.asset('images/home_search.png'),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        cursorColor: ColorConstant.greyTextColor,
        keyboardType: TextInputType.number,
      ),
    ));
  }
}
