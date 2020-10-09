import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';

//弹出搜索对话框
class MessageSearchDialog extends StatefulWidget {
  final VoidStringCallback voidStringCallback;

  const MessageSearchDialog({Key key, this.voidStringCallback})
      : super(key: key);

  @override
  _MessageSearchDialogState createState() => _MessageSearchDialogState();
}

class _MessageSearchDialogState extends State<MessageSearchDialog> {
  String _selectContent = '';
  Function mState;
  TextEditingController _searchController;
  String _hintText;

  @override
  void initState() {
    _searchController = TextEditingController();
    _hintText = '搜索姓名、电话和地址';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, mState) {
              return Material(
                type: MaterialType.transparency,
                child: Container(
                  margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(200)),
                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[_dialogWidget(mState)],
                  ),
                ),
              );
            });
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(28),
            right: ScreenUtil().setWidth(107),
            top: AutoLayout.instance.pxToDp(28)),
        height: AutoLayout.instance.pxToDp(84),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'images/rectangle_bg.png',
          ),
        )),
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(31),
                    right: ScreenUtil().setWidth(12)),
                width: ScreenUtil().setWidth(30),
                child: Image.asset(
                  'images/search.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                child: Text(
                  _hintText,
                  style: TextStyle(
                      color: ColorConstant.greyHintColor,
                      fontSize: ScreenUtil().setSp(24)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //弹出框样式
  Widget _dialogWidget(mState) {
    return Container(
      height: AutoLayout.instance.pxToDp(543),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(42), right: ScreenUtil().setWidth(42)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _closeIconWidget(),
          _messageTitleWidget(),
          _messageSingleSelectWidget(mState),
          _inputContentWidget(),
          _searchBtnWidget(),
        ],
      ),
    );
  }

  //搜索按钮
  Widget _searchBtnWidget() {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        height: AutoLayout.instance.pxToDp(76),
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(105),
            right: ScreenUtil().setWidth(105),
            top: AutoLayout.instance.pxToDp(34)),
        child: FlatButton(
            color: ColorConstant.blueTextColor,
            splashColor: Colors.transparent,
            onPressed: () {
              String searchText = _searchController.text.toString().trim();
              String data = '${_selectContent}_${searchText}';
              setState(() {
                if (_selectContent.isNotEmpty) {
                  _hintText = searchText;
                }
              });
              widget.voidStringCallback(data);
              _searchController.text = '';
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(170),
                  right: ScreenUtil().setWidth(170)),
              child: Text(
                '确定',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(26)),
              ),
            )),
      ),
    );
  }

  //关闭按钮组件
  Widget _closeIconWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: ScreenUtil().setWidth(24),
                  top: AutoLayout.instance.pxToDp(24)),
              width: ScreenUtil().setWidth(45),
              child: Image.asset(
                'images/close.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //弹出对话框标题组件
  Widget _messageTitleWidget() {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(17)),
      alignment: Alignment.center,
      child: Text(
        '选择查找条件',
        style: TextStyle(
            color: ColorConstant.blackTextColor,
            fontSize: ScreenUtil().setSp(30)),
      ),
    );
  }

  //弹出对话框单选按钮组件
  Widget _messageSingleSelectWidget(mState) {
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(61),
          left: ScreenUtil().setWidth(106),
          right: ScreenUtil().setWidth(106)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _singleRectangle('姓名', mState),
          _singleRectangle('电话', mState),
          _singleRectangle('地址', mState),
        ],
      ),
    );
  }

  //单个单选框按钮
  Widget _singleRectangle(String content, mState) {
    Color borderColor = ColorConstant.greyBorderColor;
    if (_selectContent.compareTo(content) == 0) {
      borderColor = ColorConstant.blueTextColor;
    }
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        mState(() {
          _selectContent = content;
        });
      },
      child: Container(
        width: ScreenUtil().setWidth(122),
        height: AutoLayout.instance.pxToDp(54),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: borderColor)),
        child: Text(
          content,
          style:
              TextStyle(color: borderColor, fontSize: ScreenUtil().setSp(26)),
        ),
      ),
    );
  }

  //输入框组件
  Widget _inputContentWidget() {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
      decoration: BoxDecoration(
          color: ColorConstant.greyBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(105),
          right: ScreenUtil().setWidth(105),
          top: AutoLayout.instance.pxToDp(70)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: AutoLayout.instance.pxToDp(76),
            ),
            child: TextField(
              cursorColor: ColorConstant.greyTextColor,
              controller: _searchController,
              onSubmitted: (val) {
                print('提交的内容为:${val}');
              },
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(26)),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                  hintText: '请输入搜索内容',
                  // contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: ColorConstant.greyBackgroundColor),
            ),
          )),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(28)),
            width: ScreenUtil().setWidth(30),
            child: Image.asset(
              'images/search.png',
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}
