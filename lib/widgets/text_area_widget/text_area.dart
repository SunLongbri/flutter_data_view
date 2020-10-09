import 'dart:io';
import 'package:flutter/material.dart';
import 'callback_method.dart';

class TextArea extends StatefulWidget {
  @required
  final TextEditingController textEditingController;
  final String hintText;
  @required
  final OnStatusChangeListener onStatusChangeListener;
  final double marginTop;
  final bool isShowCount;

  const TextArea(
      {Key key,
      this.textEditingController,
      this.hintText,
      this.onStatusChangeListener,
      this.marginTop = 50,
      this.isShowCount = true})
      : super(key: key);

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> with WidgetsBindingObserver {
  String commitContent = '';
  String _userInputStr = '';

  // 输入框的焦点实例
  FocusNode _focusNode;

  // 当前键盘是否是激活状态
  bool isKeyboardActived = false;

  @override
  void initState() {
    super.initState();
    String initText = widget.textEditingController.text.toString().trim();
    if (initText.isNotEmpty) {
      _userInputStr = initText;
    }
    _focusNode = FocusNode();
    // 监听输入框焦点变化
    _focusNode.addListener(_onFocus);
    // 创建一个界面变化的观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 当前是安卓系统并且在焦点聚焦的情况下
      if (Platform.isAndroid && _focusNode.hasFocus) {
        if (isKeyboardActived) {
          isKeyboardActived = false;
          // 使输入框失去焦点
          _focusNode.unfocus();
          return;
        }
        isKeyboardActived = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      onHorizontalDragEnd: (_) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      onVerticalDragEnd: (_) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        margin: EdgeInsets.only(top: widget.marginTop / 2),
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: TextField(
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          maxLines: 8,
          autocorrect: true,
          controller: widget.textEditingController,
          enableInteractiveSelection: true,
          maxLength: 150,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              bottom: 16,
              top: 8,
            ),
            counterText: widget.isShowCount
                ? _userInputStr.isEmpty
                    ? ""
                    : '还可以输入${_userInputStr.trim().length > 200 ? 0 : (200 - _userInputStr.trim().length)}个字'
                : "",
          ),
          onChanged: (String changeText) {
            setState(() {
              _userInputStr = changeText;
            });
            widget.onStatusChangeListener.onStatesComplete(changeText);
          },
        ),
      ),
    );
  }

  // 焦点变化时触发的函数
  _onFocus() {
    if (_focusNode.hasFocus) {
      // 聚焦时候的操作
      return;
    }
    // 失去焦点时候的操作
    isKeyboardActived = false;
  }

  // 既然有监听当然也要有卸载，防止内存泄漏嘛
  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
