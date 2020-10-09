import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

//单选矩形选择按钮
class SingleSelectRectangleWidget extends StatefulWidget {
  //内容
  final List<String> listContent;

  //周围边距
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;
  final VoidStringCallback stringBlock;

  const SingleSelectRectangleWidget(
      {Key key,
      this.listContent,
      this.marginLeft = 30,
      this.marginRight = 30,
      this.marginTop = 28,
      this.marginBottom = 28,
      this.stringBlock})
      : super(key: key);

  @override
  _SingleSelectRectangleWidgetState createState() => _SingleSelectRectangleWidgetState();
}

class _SingleSelectRectangleWidgetState extends State<SingleSelectRectangleWidget> {
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
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(widget.marginLeft),
          right: ScreenUtil().setWidth(widget.marginRight),
          top: AutoLayout.instance.pxToDp(widget.marginTop),
          bottom: AutoLayout.instance.pxToDp(widget.marginBottom)),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(new Radius.circular(5)),
        child: Container(
          child: Row(
            children: listContentWidget,
          ),
        ),
      ),
    );
  }

  //单个单选框央视
  Widget _singleBtn(String content) {
    Color bgColor = ColorConstant.greyBgColor;
    Color textColor = ColorConstant.blackTextColor;
    if (keyController.compareTo(content) == 0) {
      bgColor = ColorConstant.blueTextColor;
      textColor = Colors.white;
    }
    return Expanded(
        child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        print('接收到点击时间。。。');
        setState(() {
          keyController = content;
          widget.stringBlock(content);
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(70),
        color: bgColor,
        child: Text(
          content,
          style:
              TextStyle(color: textColor, fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }
}
