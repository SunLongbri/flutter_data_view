import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/text_area_widget/callback_method.dart';
import 'package:fluttermarketingplus/widgets/text_area_widget/text_area.dart';

//备注信息组件
class CommentWidget extends StatefulWidget {
  final VoidStringCallback commentStr;

  const CommentWidget({Key key, this.commentStr}) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
    implements OnStatusChangeListener {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      height: AutoLayout.instance.pxToDp(176),
      child: TextArea(
        marginTop: 20,
        hintText: '请输入备注信息',
        textEditingController: _textEditingController,
        onStatusChangeListener: this,
      ),
    );
  }

  @override
  void onStatesComplete(String commitText) {
    widget.commentStr(commitText);
  }
}
