import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

class MessageDialogWidget {
  String titles;//对话框标题
  String message;
  VoidStringCallback block;
  String negativeText;
  String positiveText;
  String textFieldContent;//初始化文本文字
  String textFieldHintContent;//初始化提示性文本文字
  Function onCloseEvent;
  Function onPositivePressEvent;
  Function onConfirmEvent;

  MessageDialogWidget({
    Key key,
    @required this.titles,
    @required this.message,
    this.negativeText,
    this.positiveText,
    this.textFieldContent,
    this.textFieldHintContent,
    this.onPositivePressEvent,
    this.block,
    this.onConfirmEvent,
    @required this.onCloseEvent,
  });

  Future<String> show(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, mSetState) {
            return MessageDialog(
              title: titles,
              message: message,
              negativeText: negativeText,
              positiveText: positiveText,
              onCloseEvent: onCloseEvent,
              block: block,
              textFieldContent: textFieldContent,
              textFieldHintContent: textFieldHintContent,
              onConfirmEvent: onConfirmEvent,
              onPositivePressEvent: onPositivePressEvent,
            );
          });
        });
  }
}

class MessageDialog extends Dialog {
  String title;
  String message;
  String negativeText;
  String positiveText;
  String textFieldContent;
  String textFieldHintContent;
  Function onCloseEvent;
  VoidStringCallback block;
  Function onPositivePressEvent;
  Function onConfirmEvent;

  MessageDialog({
    Key key,
    @required this.title,
    @required this.message,
    this.negativeText,
    this.block,
    this.positiveText,
    this.onPositivePressEvent,
    this.textFieldContent,
    this.textFieldHintContent,
    this.onConfirmEvent,
    @required this.onCloseEvent,
  }) : super(key: key);

  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    _textEditingController = TextEditingController(text: textFieldContent);
    return StatefulBuilder(builder: (context, mSetState) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: ShapeDecoration(
                  color: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                margin: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          Center(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 19.0,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: this.onCloseEvent,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.close,
                                color: Color(0xffe0e0e0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    message.isEmpty
                        ? Container()
                        : Container(
                            color: Color(0xffe0e0e0),
                            height: 1.0,
                          ),
                    message.isEmpty
                        ? Container(
                            height: AutoLayout.instance.pxToDp(220),
                            width: ScreenUtil().setWidth(564),
                            margin: EdgeInsets.only(
                                bottom: AutoLayout.instance.pxToDp(36)),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: ColorConstant.greyLineColor,
                                )),
                            child: TextField(
                              controller: _textEditingController,
                              cursorColor: ColorConstant.greyLineColor,
                              style: TextStyle(
                                  color: ColorConstant.blackTextColor,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: textFieldHintContent == null?'请输入要修改的地址':textFieldHintContent,
                                  hintStyle: TextStyle(fontSize: 14)),
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(minHeight: 180.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: IntrinsicHeight(
                                child: Text(
                                  message,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                    this._buildBottomButtonGroup(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    if (negativeText == null && positiveText == null) {
      widgets.add(_btnConfirmWidget());
    }
    return Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _btnConfirmWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(50),
          bottom: AutoLayout.instance.pxToDp(36)),
      child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          color: ColorConstant.blueBgColor,
          onPressed: () {
            block(_textEditingController.text.toString().trim());
            onConfirmEvent;
          },
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(500),
            child: Text(
              '确定',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32), color: Colors.white),
            ),
          )),
    );
  }

  Widget _buildBottomCancelButton() {
    return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
        onPressed: onCloseEvent,
        child: Text(
          negativeText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton() {
    return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
        onPressed: onPositivePressEvent,
        child: Text(
          positiveText,
          style: TextStyle(
            color: Color(Colors.teal.value),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
