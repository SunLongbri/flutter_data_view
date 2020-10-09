import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:oktoast/oktoast.dart';

//新增任务量页面
class AddTaskCountPage extends StatefulWidget {
  @override
  _AddTaskCountPageState createState() => _AddTaskCountPageState();
}

class _AddTaskCountPageState extends State<AddTaskCountPage> {
  List<String> _contentList = ['王二', '张三', '李四', '王武'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '新增任务',
        actionsWidget: _actionWidget(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _singleSelectBar(),
          _titleBar(),
          _dataList(),
        ],
      ),
    );
  }

  Widget _actionWidget() {
    return InkWell(
      onTap: () {
        showToast('提交按钮正在开发....');
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        child: Image.asset(
          'images/complete.png',
          width: ScreenUtil().setWidth(44),
        ),
      ),
    );
  }

  //单选bar
  Widget _singleSelectBar() {
    return SingleSelectIndicatorWidget(
      listContent: ['下周', '下个月', '下个季度', '明年'],
      stringBlock: (content) {
        print('新增任务：${content}');
      },
    );
  }

  //标题栏
  Widget _titleBar() {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(24)),
      color: Colors.white,
      child: Row(
        children: [
          _singleColumnWidget('姓名'),
          _singleColumnWidget('鲜花单量'),
          _singleColumnWidget('鲜花实收'),
          _singleColumnWidget('洗涤单量'),
          _singleColumnWidget('洗涤实收'),
        ],
      ),
    );
  }

  //数据列表
  Widget _dataList() {
    return Expanded(
        child: ListView.builder(
            itemCount: _contentList.length,
            itemBuilder: (BuildContext context, int position) {
              //todo：鉴于有未知个要保存小哥的信息，在获取到小哥信息之后，for循环，每次循环创建Controller来保存用户输入的信息
              return _singleRowWidget(
                  _contentList[position],
                  TextEditingController(),
                  TextEditingController(),
                  TextEditingController(),
                  TextEditingController());
            }));
  }

  //标题单个单元格
  Widget _singleColumnWidget(String content) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      height: AutoLayout.instance.pxToDp(70),
      child: Text(
        content,
        style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25)),
      ),
    ));
  }

  //数据存储单行
  Widget _singleRowWidget(
      String name,
      TextEditingController controller1,
      TextEditingController controller2,
      TextEditingController controller3,
      TextEditingController controller4) {
    return Container(
      padding: EdgeInsets.only(
          bottom: AutoLayout.instance.pxToDp(16),
          top: AutoLayout.instance.pxToDp(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(70),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(25)),
            ),
          )),
          _singleTableWidget(
            TextEditingController(),
          ),
          _singleTableWidget(
            TextEditingController(),
          ),
          _singleTableWidget(
            TextEditingController(),
          ),
          _singleTableWidget(
            TextEditingController(),
          ),
        ],
      ),
    );
  }

  //数据存储单元格
  Widget _singleTableWidget(
    TextEditingController textEditingController,
  ) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(10), right: ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorConstant.greyTextColor),
          borderRadius: BorderRadius.circular(5)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 30, maxWidth: 200),
        child: TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: ScreenUtil().setSp(25)),
          cursorColor: ColorConstant.greyLineColor,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    ));
  }
}
