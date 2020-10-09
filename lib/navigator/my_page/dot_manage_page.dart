import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';

import 'dot_manage_page/business_select_widget.dart';
import 'dot_manage_page/data_statistics_widget.dart';
import 'dot_manage_page/over_rate_widget.dart';
import 'dot_manage_page/single_dot_widget.dart';
import 'dot_manage_page/task_manage_widget.dart';

//网点管理报表
class DotManagePage extends StatefulWidget {
  @override
  _DotManagePageState createState() => _DotManagePageState();
}

class _DotManagePageState extends State<DotManagePage> {
  //昨日天山业绩
  //是否弹出菜单
  bool isPopMenu;

  @override
  void initState() {
    isPopMenu = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '网点管理报表',
        actionsWidget: _actionWidget(),
        actionPress: () {
          setState(() {
            if (isPopMenu) {
              isPopMenu = false;
            } else {
              isPopMenu = true;
            }
          });
        },
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                SingleDotWidget(),
                BussinessSelectWidget(),
                DataStatisticsWidget(),
                TaskManageWidget(),
                OverRateWidget(),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset(1.0, 0.01),
            child: isPopMenu
                ? Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: AutoLayout.instance.pxToDp(149),
                    width: ScreenUtil().setWidth(237),
                    child: Column(
                      children: <Widget>[
                        _singleItemWidget('images/task_add.png', '新增客户'),
                        _singleItemWidget('images/task_setting.png', '任务量设置'),
                      ],
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  //弹出菜单单选按钮组件
  Widget _singleItemWidget(
    String imageAsset,
    String content,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        print('点击的内容为:${content}');
        if (content.compareTo('新增客户') == 0) {
          JumpReceive().jump(context, Routes.addConsumerPage,
              paramsName: 'data', sendData: '录入客户信息');
        } else if (content.compareTo('任务量设置') == 0) {
          JumpReceive().jump(context, Routes.addTaskPage);
        }
        setState(() {
          isPopMenu = false;
        });
      },
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(18), right: ScreenUtil().setWidth(18)),
        child: Container(
          height: AutoLayout.instance.pxToDp(72),
          alignment: Alignment.center,
          decoration: content.contains('新增')
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 0.1)))
              : null,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(12)),
                width: ScreenUtil().setWidth(28),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                child: Text(
                  content,
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(26)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return Container(
      width: ScreenUtil().setWidth(44),
      child: Image.asset(
        'images/add.png',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
