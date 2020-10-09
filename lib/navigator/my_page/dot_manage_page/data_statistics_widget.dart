import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/dot_statistics_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/item_title_widget.dart';
import 'package:oktoast/oktoast.dart';

//数据统计
class DataStatisticsWidget extends StatefulWidget {
  @override
  _DataStatisticsWidgetState createState() => _DataStatisticsWidgetState();
}

class _DataStatisticsWidgetState extends State<DataStatisticsWidget> {
  //列表数据
  List<Data> _listData;

  //是否加载数据
  bool _isReloadData;

  @override
  void initState() {
    _isReloadData = true;
    _listData = [];
    getRequest(API.DOT_STATISTICS).then((val) {
      print('数据统计:${val}');
      if (!_isReloadData) {
        //停止加载数据
        return;
      }
      DotStaticsModel dotStaticsModel = DotStaticsModel.fromJson(val);
      if (dotStaticsModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (dotStaticsModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        setState(() {
          _listData = dotStaticsModel.data;
        });
      } else {
        //数据返回失败
        showToast('网络开小车了,请稍后再试!');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _isReloadData = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(440),
      child: Column(
        children: [
          _space(),
          ItemTitleWidget(
            '数据统计',
            marginTop: 10,
          ),
          _titleRowWidget(),
          Expanded(
              child: ListView.builder(
                  itemCount: _listData.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _singleCountWidget(
                        _listData[position].nickname,
                        _listData[position].empid,
                        _listData[position].myCustomer.toString(),
                        _listData[position].village.toString(),
                        _listData[position].customer.toString(),
                        _listData[position].rate.toString());
                  })),
        ],
      ),
    );
  }

  Widget _space() {
    return Container(
      height: AutoLayout.instance.pxToDp(24),
      color: ColorConstant.greyBgColor,
    );
  }

  //单行数据表组件
  Widget _singleCountWidget(String name, String workNum, String consumerCount,
      String serviceVillage, String serviceConsumer, String consumerRate) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          _singleRowCellWidget(name, 1, textColor: ColorConstant.greyTextColor),
          _singleRowCellWidget(workNum, 1,
              textColor: ColorConstant.greyTextColor),
          _singleRowCellWidget(consumerCount, 1,
              textColor: ColorConstant.greyTextColor),
          _singleRowCellWidget(serviceVillage, 1,
              textColor: ColorConstant.greyTextColor),
          Expanded(
              child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                top: AutoLayout.instance.pxToDp(10),
                bottom: AutoLayout.instance.pxToDp(10)),
            child: Column(
              children: [
                Text(
                  serviceConsumer,
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(30)),
                ),
                Text(
                  '${consumerRate}%转化率',
                  style: TextStyle(
                      color: ColorConstant.blueTextColor,
                      fontSize: ScreenUtil().setSp(20)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  //标题栏组件
  Widget _titleRowWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: [
          _singleRowCellWidget('小哥', 2),
          _singleRowCellWidget('工号', 2),
          _singleRowCellWidget('营销客户量', 2),
          _singleRowCellWidget('服务小区', 2),
          _singleRowCellWidget('服务用户', 2),
        ],
      ),
    );
  }

  //单个标题栏组件
  Widget _singleRowCellWidget(String content, int flex,
      {Color textColor = ColorConstant.blackTextColor}) {
    return Expanded(
        flex: flex,
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(15),
              bottom: AutoLayout.instance.pxToDp(15)),
          child: Text(
            content,
            style:
                TextStyle(color: textColor, fontSize: ScreenUtil().setSp(25)),
          ),
        ));
  }
}
