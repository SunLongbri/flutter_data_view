import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//商品瑕疵组件
class GoodsFlawWidget extends StatefulWidget {
  final ListStringCallBack listStrBlock;

  const GoodsFlawWidget({Key key, this.listStrBlock}) : super(key: key);

  @override
  _GoodsFlawWidgetState createState() => _GoodsFlawWidgetState();
}

class _GoodsFlawWidgetState extends State<GoodsFlawWidget> {
  //瑕疵品列表
  List<String> _flawList = [
    '磨损',
    '水渍印',
    '油笔芯印',
    '染色',
    '油渍',
    '脱落',
    '折痕',
    '划痕',
    '发黄',
    '发黑',
    '发霉',
    '脱胶脱线'
  ];

  //瑕疵品组件数组
  List<Widget> _flawWidgets = [];

  //小哥选择的瑕疵品
  List<String> _userSelect = [];

  @override
  Widget build(BuildContext context) {
    _flawWidgets.clear();
    for (int i = 0; i < _flawList.length; i++) {
      _flawWidgets.add(_singleCornerWidget(_flawList[i]));
    }
    return Container(
      height: AutoLayout.instance.pxToDp(296),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(20)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleWidget(),
          Wrap(
            children: _flawWidgets,
          ),
        ],
      ),
    );
  }

  //单个选项组件
  Widget _singleCornerWidget(String content) {
    bool _isSelect = false;
    if (_userSelect.contains(content)) {
      _isSelect = true;
    }
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          if (_userSelect.contains(content)) {
            _userSelect.remove(content);
          } else {
            _userSelect.add(content);
          }
          widget.listStrBlock(_userSelect);
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            top: AutoLayout.instance.pxToDp(20),
            right: ScreenUtil().setWidth(10)),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(156),
        height: AutoLayout.instance.pxToDp(48),
        decoration: BoxDecoration(
            color: _isSelect ? null : Color(0xffE3F5FF),
            gradient: _isSelect
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff4FD8FD),
                      Color(0xff42CAFB),
                      Color(0xff3CC5FB),
                      Color(0xff27AFF9),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(
          content,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(26),
              color: _isSelect ? Colors.white : Color(0xff29B1F9)),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(78),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: ColorConstant.greyLineColor,
      ))),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(6),
            height: AutoLayout.instance.pxToDp(28),
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(7)),
            child: Text(
              '商品瑕疵',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
