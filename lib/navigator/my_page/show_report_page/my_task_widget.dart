import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/my_task_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:oktoast/oktoast.dart';

//我的任务
class MyTaskWidget extends StatefulWidget {
  @override
  _MyTaskWidgetState createState() => _MyTaskWidgetState();
}

class _MyTaskWidgetState extends State<MyTaskWidget> {
  //鲜花数量
  List<String> flowerCountList = ['', '', '', '', ''];

  //鲜花金额
  List<String> flowerMoneyList = ['', '', '', '', ''];

  //洗涤数量
  List<String> washCountList = ['', '', '', '', ''];

  //洗涤金额
  List<String> washMoneyList = ['', '', '', '', ''];

  @override
  void initState() {
    getRequest(API.REPORT_MY_TASK, queryParameters: {"user_id": "461"})
        .then((val) {
      print('我的任务返回的数据为:${val}');
      MyTaskModel myTaskModel = MyTaskModel.fromJson(val);
      if (myTaskModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (myTaskModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        List<TaskData> listTaskData = myTaskModel.data.list;
        setState(() {
          for (int i = 0; i < listTaskData.length; i++) {
            int _flag = listTaskData[i].flag;
            if (_flag == 1) {
              //下周
              String flowerCount = listTaskData[i].flowerCount;
              String flowerMoney = listTaskData[i].flowerMoney;
              String washCount = listTaskData[i].washCount;
              String washMoney = listTaskData[i].washMoney;
              flowerCountList.insert(_flag, flowerCount);
              flowerMoneyList.insert(_flag, flowerMoney);
              washCountList.insert(_flag, washCount);
              washMoneyList.insert(_flag, washMoney);
            } else if (_flag == 2) {
              //下个月
              String flowerCount = listTaskData[i].flowerCount;
              String flowerMoney = listTaskData[i].flowerMoney;
              String washCount = listTaskData[i].washCount;
              String washMoney = listTaskData[i].washMoney;
              flowerCountList.insert(_flag, flowerCount);
              flowerMoneyList.insert(_flag, flowerMoney);
              washCountList.insert(_flag, washCount);
              washMoneyList.insert(_flag, washMoney);
            } else if (_flag == 3) {
              //下个季度
              String flowerCount = listTaskData[i].flowerCount;
              String flowerMoney = listTaskData[i].flowerMoney;
              String washCount = listTaskData[i].washCount;
              String washMoney = listTaskData[i].washMoney;
              flowerCountList.insert(_flag, flowerCount);
              flowerMoneyList.insert(_flag, flowerMoney);
              washCountList.insert(_flag, washCount);
              washMoneyList.insert(_flag, washMoney);
            } else if (_flag == 4) {
              //明年
              String flowerCount = listTaskData[i].flowerCount;
              String flowerMoney = listTaskData[i].flowerMoney;
              String washCount = listTaskData[i].washCount;
              String washMoney = listTaskData[i].washMoney;
              flowerCountList.insert(_flag, flowerCount);
              flowerMoneyList.insert(_flag, flowerMoney);
              washCountList.insert(_flag, washCount);
              washMoneyList.insert(_flag, washMoney);
            }
          }
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: AutoLayout.instance.pxToDp(34)),
      child: Column(
        children: [
          _titleWidget(),
          _flowerTableRow(flowerCountList, flowerMoneyList),
          _washTableRow(washCountList, washMoneyList)
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(80),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(17)),
            width: ScreenUtil().setWidth(10),
            height: AutoLayout.instance.pxToDp(32),
            color: ColorConstant.blueTextColor,
          ),
          Text(
            '我的任务',
            style: TextStyle(
                color: ColorConstant.blackTextColor,
                fontSize: ScreenUtil().setSp(30)),
          )
        ],
      ),
    );
  }

  //洗涤任务表格
  Widget _washTableRow(List<String> washCountList, List<String> washMoneyList) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: AutoLayout.instance.pxToDp(89),
            child: Text(
              '洗涤',
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(10)),
            child: Table(
              //每列列宽
              columnWidths: const {
                //列宽
                0: FixedColumnWidth(66),
                1: FixedColumnWidth(69),
                2: FixedColumnWidth(69),
                3: FixedColumnWidth(69),
                4: FixedColumnWidth(70),
              },
              //表格边框样式
              border: TableBorder.all(
                  color: ColorConstant.greyLineColor,
                  width: 1.0,
                  style: BorderStyle.solid),
              children: [
                TableRow(children: [
                  _singleCellWidget('洗涤'),
                  _singleCellWidget('下周'),
                  _singleCellWidget('下个月'),
                  _singleCellWidget('下一季度'),
                  _singleCellWidget('明年'),
                ]),
                TableRow(children: [
                  _singleCellWidget('单量'),
                  _singleCellWidget(washCountList[1]),
                  _singleCellWidget(washCountList[2]),
                  _singleCellWidget(washCountList[3]),
                  _singleCellWidget(washCountList[4]),
                ]),
                TableRow(children: [
                  _singleCellWidget('金额'),
                  _singleCellWidget(washMoneyList[1]),
                  _singleCellWidget(washMoneyList[2]),
                  _singleCellWidget(washMoneyList[3]),
                  _singleCellWidget(washMoneyList[4]),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  //鲜花任务表格
  Widget _flowerTableRow(
      List<String> flowerCountList, List<String> flowerMoneyList) {
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(10),
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30)),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height: AutoLayout.instance.pxToDp(89),
            child: Text(
              '鲜花',
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          Table(
            //每列列宽
            columnWidths: const {
              //列宽
              0: FixedColumnWidth(66),
              1: FixedColumnWidth(69),
              2: FixedColumnWidth(69),
              3: FixedColumnWidth(69),
              4: FixedColumnWidth(70),
            },
            //表格边框样式
            border: TableBorder.all(
                color: ColorConstant.greyLineColor,
                width: 1.0,
                style: BorderStyle.solid),
            children: [
              TableRow(children: [
                _singleCellWidget('鲜花'),
                _singleCellWidget('下周'),
                _singleCellWidget('下个月'),
                _singleCellWidget('下一季度'),
                _singleCellWidget('明年'),
              ]),
              TableRow(children: [
                _singleCellWidget('单量'),
                _singleCellWidget(flowerCountList[1]),
                _singleCellWidget(flowerCountList[2]),
                _singleCellWidget(flowerCountList[3]),
                _singleCellWidget(flowerCountList[4]),
              ]),
              TableRow(children: [
                _singleCellWidget('金额'),
                _singleCellWidget(flowerMoneyList[1]),
                _singleCellWidget(flowerMoneyList[2]),
                _singleCellWidget(flowerMoneyList[3]),
                _singleCellWidget(flowerMoneyList[4]),
              ]),
            ],
          )
        ],
      ),
    );
  }

  Widget _singleCellWidget(String content) {
    Color textColor = ColorConstant.greyTextColor;
    if (content.contains('鲜花') || content.contains('洗涤')) {
      textColor = ColorConstant.blueTextColor;
    }
    return Container(
      alignment: Alignment.center,
      height: 30,
      child: Text(
        content,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
