import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/yesterday_achievement_model.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/item_title_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';

//单个网点营销情况
class SingleDotWidget extends StatefulWidget {
  @override
  _SingleDotWidgetState createState() => _SingleDotWidgetState();
}

class _SingleDotWidgetState extends State<SingleDotWidget> {
  //昨日门店业绩数据列表
  List<Data> listData;

  //洗涤
  String _washCount;
  String _washPrice;
  String _washCommission;

  //鲜花
  String _flowerPrice;
  String _flowerCount;
  String _flowerCommission;

  //门店名称
  String _storeName;

  //是否加载数据
  bool _isLoading;

  bool _loadData;

  @override
  void initState() {
    _loadData = true;
    _isLoading = false;
    _washCount = '';
    _washPrice = '';
    _washCommission = '';
    _flowerPrice = '';
    _flowerCount = '';
    _flowerCommission = '';
    _storeName = '';
    _getInitData();
    super.initState();
  }

  @override
  void dispose() {
    _loadData = false;
    super.dispose();
  }

  void _getInitData() {
    listData = [];
    Map<String, String> params = {"user_id": "461"};
    setState(() {
      _isLoading = true;
    });
    getRequest(API.DOT_YESTERDAY_ACHIEVEMENT, queryParameters: params)
        .then((val) {
      if (!_loadData) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      print('val:${val}');
      YesterdayAchievementModel yesterdayAchievementModel =
          YesterdayAchievementModel.fromJson(val);
      if (yesterdayAchievementModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (yesterdayAchievementModel.status ==
          GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        listData = yesterdayAchievementModel.data;
        setState(() {
          for (int i = 0; i < listData.length; i++) {
            if (listData[i].type.compareTo('wash') == 0) {
              _washCount = listData[i].count;
              _washPrice = listData[i].price;
              _washCommission = listData[i].commission;
              _storeName = listData[i].station;
            } else if (listData[i].type.compareTo('plant') == 0) {
              _flowerCount = listData[i].count;
              _flowerPrice = listData[i].price;
              _flowerCommission = listData[i].commission;
            }
          }
        });
      } else {
        //数据返回失败
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      marginTop: 100,
      cover: true,
      isLoading: _isLoading,
      child: Column(
        children: [
          ItemTitleWidget(
            '昨日${_storeName}业绩',
          ),
          _singleAchievementLine(
              '洗涤',
              '${_washCount}单',
              '实收金额¥${_washPrice == null ? '0' : _washPrice}',
              '提成¥${_washCommission == null ? '0' : _washCommission}'),
          _singleAchievementLine(
              '鲜花',
              '${_flowerCount}单',
              '实收金额¥${_flowerPrice == null ? '0' : _flowerPrice}',
              '提成¥${_flowerCommission == null ? '0' : _flowerCommission}'),
          _attendanceWidget('上周小哥出勤率', ''),
          _deliverStepsRankWidget('门店客户管理'),
          _space()
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

  //小哥步数排名
  Widget _deliverStepsRankWidget(String title) {
    return InkWell(
      onTap: () {
        JumpReceive().jump(context, Routes.customerManagementPage);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            top: AutoLayout.instance.pxToDp(15),
            bottom: AutoLayout.instance.pxToDp(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.w500),
            ),
            _forwardArrow()
          ],
        ),
      ),
    );
  }

  //小哥出勤率
  Widget _attendanceWidget(String firstAttendance, String secondAttendance) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showToast('该功能正在开发中,敬请期待...');
        return;
        JumpReceive().jump(context, Routes.myAttendancePage,
            paramsName: 'titledata', sendData: '小哥出勤');
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            top: AutoLayout.instance.pxToDp(15),
            bottom: AutoLayout.instance.pxToDp(15)),
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: Row(
                children: [
                  Text(
                    firstAttendance,
                    style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: ScreenUtil().setSp(24)),
                  ),
                  Text(
                    secondAttendance,
                    style: TextStyle(
                        color: ColorConstant.deepRedTextColor,
                        fontSize: ScreenUtil().setSp(24)),
                  ),
                ],
              ),
            )),
            _forwardArrow()
          ],
        ),
      ),
    );
  }

  //当行业绩数据展示
  Widget _singleAchievementLine(
      String orderName, String orderCount, String money, String getMoney) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        JumpReceive().jump(context, Routes.botherAchievementPage);
      },
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
        child: Row(
          children: [
            _singleTable(orderName, 1),
            _singleTable(orderCount, 1),
            _singleTable(money, 3),
            _singleTable(getMoney, 2),
          ],
        ),
      ),
    );
  }

  //文字单个单元格
  Widget _singleTable(String text, int flex) {
    String keyWord = '';
    if (text.contains('¥')) {
      keyWord = '¥${text.split('¥')[1]}';
      text = text.split('¥')[0];
    }
    return Expanded(
        flex: flex,
        child: Container(
          padding: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(10),
              bottom: AutoLayout.instance.pxToDp(10)),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(26)),
              ),
              Text(
                keyWord,
                style: TextStyle(
                    color: ColorConstant.blueTextColor,
                    fontSize: ScreenUtil().setSp(26)),
              )
            ],
          ),
        ));
  }

  //条目箭头
  Widget _forwardArrow() {
    return InkWell(
      onTap: () {
        print('点击了详情按钮 ... ');
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(10), right: ScreenUtil().setWidth(10)),
        width: ScreenUtil().setWidth(9),
        height: AutoLayout.instance.pxToDp(17),
        child: Image.asset(
          'images/arrow.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
