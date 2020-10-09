import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//单选底部引导器选择按钮
class SingleSelectIndicatorWidget extends StatefulWidget {
  //内容
  @required
  final List<String> listContent;

  //返回回调
  @required
  final VoidStringCallback stringBlock;

  //周围边距
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  const SingleSelectIndicatorWidget(
      {Key key,
      this.listContent,
      this.paddingLeft = 30,
      this.paddingRight = 30,
      this.paddingTop = 1,
      this.paddingBottom = 28,
      this.stringBlock})
      : super(key: key);

  @override
  _SingleSelectIndicatorWidgetState createState() =>
      _SingleSelectIndicatorWidgetState();
}

class _SingleSelectIndicatorWidgetState
    extends State<SingleSelectIndicatorWidget> {
  //单选组件文字
  List<String> listContentString;

  //单选组件合集
  List<Widget> listContentWidget = [];

  //单选控制器
  String keyController;

  @override
  void initState() {
    listContentString = widget.listContent;
    keyController = listContentString[0] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    listContentWidget.clear();
    for (int i = 0; i < listContentString.length; i++) {
      listContentWidget.add(_singleBtn(listContentString[i]));
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(widget.paddingLeft),
          right: ScreenUtil().setWidth(widget.paddingRight),
          top: AutoLayout.instance.pxToDp(widget.paddingTop),
          bottom: AutoLayout.instance.pxToDp(widget.paddingBottom)),
      child: Container(
        child: Row(
          children: listContentWidget,
        ),
      ),
    );
  }

  //单个单选框样式
  Widget _singleBtn(String content) {
    Color textColor = ColorConstant.blackTextColor;
    Color borderColor = Colors.white;
    if (keyController.compareTo(content) == 0) {
      textColor = ColorConstant.blueTextColor;
      borderColor = ColorConstant.blueTextColor;
    }
    return Expanded(
        child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          keyController = content;
          widget.stringBlock(content);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: borderColor, style: BorderStyle.solid, width: 2))),
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(70),
        child: Text(
          content,
          style: TextStyle(
              color: textColor,
              fontSize: ScreenUtil().setSp(30),
              fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }
}
