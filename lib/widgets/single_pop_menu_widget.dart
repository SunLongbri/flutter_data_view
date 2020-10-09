import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';

//底部弹窗式组件
class SinglePopMenuWidget extends StatefulWidget {
  final String head;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const SinglePopMenuWidget(
      {Key key,
      @required this.head,
      @required this.options,
      @required this.onSelected})
      : super(key: key);

  @override
  _SinglePopMenuWidgetState createState() => _SinglePopMenuWidgetState();
}

class _SinglePopMenuWidgetState extends State<SinglePopMenuWidget> {
  String selectValue;
  List<String> _listItem;

  @override
  void initState() {
    _listItem = widget.options;
    selectValue = _listItem[0] ?? '暂无数据';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
        child: DropdownButton(
          elevation: 1,
//          hint: Text(
//            widget.head,
//            style: TextStyle(fontSize: ScreenUtil().setSp(20)),
//          ),
          items: getItems(),
          value: widget.head??'暂无数据',
          onChanged: widget.onSelected,
        ));
  }

  getItems() {
    var items = List<DropdownMenuItem<String>>();
    for (int i = 0; i < _listItem.length; i++) {
      items.add(_singleItemWidget(_listItem[i], _listItem[i]));
    }
    return items;
  }

  //单个条目样式组件
  Widget _singleItemWidget(String content, String value) {
    return DropdownMenuItem(
      child: Container(
        child: Text(
          content,
          style: TextStyle(fontSize: ScreenUtil().setSp(25)),
        ),
      ),
      value: value,
    );
  }
}
