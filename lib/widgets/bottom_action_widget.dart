import 'package:flutter/cupertino.dart';

//苹果风格 底部弹窗选项框
class BottomActionWidget {
  String topTitle; //最顶部标题显示
  String bottomTitle; //顶部稍靠下标题显示
  List<String> itemList; //底部弹窗 条目选项列表
  List<Widget> itemListWidget; //列表widget

  BottomActionWidget(
      {this.topTitle = '', this.bottomTitle = '', this.itemList = const []});

  Future<String> show(BuildContext context) async {
    _initItem(context);
    return await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: topTitle.isEmpty ? null : Text(topTitle),
          message: bottomTitle.isEmpty ? null : Text(bottomTitle),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消'),
            onPressed: () {
              Navigator.pop(context, '取消');
            },
          ),
          actions: itemListWidget,
        );
      },
    );
  }

  _initItem(BuildContext context) {
    itemListWidget = [];
    for (int i = 0; i < itemList.length; i++) {
      itemListWidget.add(_singleItem(context, itemList[i]));
    }
  }

  Widget _singleItem(BuildContext context, String itemContent) {
    return CupertinoActionSheetAction(
      child: Text(itemContent),
      onPressed: () {
        Navigator.pop(context, itemContent);
      },
    );
  }
}
