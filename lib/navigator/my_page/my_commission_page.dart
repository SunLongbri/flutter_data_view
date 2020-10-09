import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/myCommission_model.dart';
import 'package:fluttermarketingplus/model/my_commission_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart'
    as HandOverDutyDatePicker;

//我的佣金页面
class MyCommissionPage extends StatefulWidget {
  @override
  _MyCommissionPageState createState() => _MyCommissionPageState();
}

class _MyCommissionPageState extends State<MyCommissionPage> {
  //用户选择的月份
  String selectMonth;

  //用户选择的年份
  String selectYear;

  //分页加载-页数
  int _pageIndex;

  //请求接口的参数
  Map<String, String> params;

  //我的佣金数据总量
  int _totalCount;

  //我的佣金数据列表
  List<DataList> _commissionDataList;
  bool _isLoading;
  List<MyCommission> consumerList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildCtn() {
    return ListView.separated(
      itemBuilder: (c, i) => Item(
        myCommission: consumerList[i],
      ),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: ColorConstant.greyLineColor,
        );
      },
      itemCount: consumerList.length,
    );
  }

  @override
  void initState() {
    _isLoading = false;
    _totalCount = 0;
    var now = new DateTime.now();
    int year = now.year;
    int month = now.month;
    _pageIndex = 1;
    selectMonth = '';
    selectYear = year.toString();
    if (month < 10) {
      selectMonth = '0${month}';
    }
    print('year:${selectYear},month:${selectMonth}');
    _refreshCommissionData(selectYear, selectMonth);
    super.initState();
  }

  //刷新我的佣金列表数据
  void _refreshCommissionData(String selectYear, String selectMonth) {
    params = {
      "year": selectYear,
      "month": selectMonth,
      "pageindex": _pageIndex.toString(),
      "pagesize": "20"
    };
    setState(() {
      _isLoading = true;
    });
    getRequest(API.MY_COMMISSION, queryParameters: params).then((val) {
      setState(() {
        _isLoading = false;
      });
      print('val:${val}');
      MyCommissionModel myCommissionModel = MyCommissionModel.fromJson(val);
      if (myCommissionModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (myCommissionModel.status == GlobalData.REQUEST_SUCCESS) {
        setState(() {
          _totalCount = int.parse(myCommissionModel.data.total);
          _commissionDataList = myCommissionModel.data.list;
          for (int i = 0; i < _commissionDataList.length; i++) {
            MyCommission myCommission = MyCommission(
                orderId: _commissionDataList[i].orderId.toString(),
                num: _commissionDataList[i].realprice.toString(),
                proportion: '${_commissionDataList[i].commissionRate * 100}%',
                commission: _commissionDataList[i].realcommission.toString(),
                date: _commissionDataList[i].createDatetime.split(' ')[0]);
            consumerList.add(myCommission);
          }
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  Widget _actionWidget() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        HandOverDutyDatePicker.DatePicker.showDatePicker(
          context,
          dateFormat: 'yyyy年      MMMM月',
          locale: DateTimePickerLocale.zh_cn,
          pickerMode: DateTimePickerMode.date,
          maxDateTime: DateTime.now(),
          //选择器种类
          onCancel: () {},
          onClose: () {},
          onChange: (data, i) {
            print(data);
          },
          onConfirm: (data, i) {
            consumerList.clear();
            print(data);
            setState(() {
              _pageIndex = 1;
              selectYear = data.year.toString();
              if (data.month < 10) {
                selectMonth = '0${data.month}';
              } else {
                selectMonth = data.month.toString();
              }
            });
            _refreshCommissionData(selectYear, selectMonth);
          },
        );
      },
      child: Container(
        width: ScreenUtil().setWidth(44),
        child: Image.asset(
          'images/my_coustomer_time.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "我的佣金",
        actionsWidget: _actionWidget(),
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: consumerList.length != 0
            ? Column(
                children: <Widget>[
                  Divider(
                    height: ScreenUtil().setHeight(24),
                    color: ColorConstant.greyBgColor,
                  ),
                  Container(
                    color: Colors.white,
                    height: ScreenUtil().setHeight(74),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text("订单号码",
                                    style: TextStyle(
                                        color: ColorConstant.blackTextColor,
                                        fontSize: ScreenUtil().setSp(30)),
                                    textAlign: TextAlign.center)),
                            Expanded(
                                child: Text("实付金额",
                                    style: TextStyle(
                                        color: ColorConstant.blackTextColor,
                                        fontSize: ScreenUtil().setSp(30)),
                                    textAlign: TextAlign.center)),
                            Expanded(
                                child: Text("提成比例",
                                    style: TextStyle(
                                        color: ColorConstant.blackTextColor,
                                        fontSize: ScreenUtil().setSp(30)),
                                    textAlign: TextAlign.center)),
                            Expanded(
                                child: Text("佣金",
                                    style: TextStyle(
                                        color: ColorConstant.blackTextColor,
                                        fontSize: ScreenUtil().setSp(30)),
                                    textAlign: TextAlign.center)),
                            Expanded(
                                child: Text("签收日期",
                                    style: TextStyle(
                                        color: ColorConstant.blackTextColor,
                                        fontSize: ScreenUtil().setSp(30)),
                                    textAlign: TextAlign.center)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullUp: true,
                      enablePullDown: false,
                      child: buildCtn(),
                      footer: ClassicFooter(
                        loadStyle: LoadStyle.ShowWhenLoading,
                        completeDuration: Duration(milliseconds: 500),
                      ),
                      header: WaterDropHeader(),
                      onLoading: () async {
                        _pageIndex++;
                        _refreshCommissionData(selectYear, selectMonth);
                        if (_totalCount < (_pageIndex * 20)) {
//                    showToast('没有更多数据了!');
                          _refreshController.loadNoData();
                        } else {
                          _refreshController.loadComplete();
                        }
                      },
                    ),
                  ),
                ],
              )
            : _isLoading ? Container() : _noDataWidget(),
      ),
    );
  }
}

Widget _noDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        alignment: Alignment.center,
        child: Image.asset(
          'images/no_data.png',
          width: ScreenUtil().setWidth(374),
          fit: BoxFit.fitWidth,
        ),
      ),
      Text(
        '暂无数据',
        style: TextStyle(
            color: ColorConstant.greyTextColor,
            fontSize: ScreenUtil().setSp(25)),
      )
    ],
  );
}

class Item extends StatefulWidget {
  final MyCommission myCommission;

  Item({this.myCommission});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          height: ScreenUtil().setHeight(80),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.myCommission.orderId,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorConstant.blueTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                ),
              ),
              Expanded(
                  child: Text(widget.myCommission.num,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorConstant.greyTextColor,
                          fontSize: ScreenUtil().setSp(26)))),
              Expanded(
                child: Text(widget.myCommission.proportion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorConstant.greyTextColor,
                        fontSize: ScreenUtil().setSp(26))),
              ),
              Expanded(
                  child: Text(widget.myCommission.commission,
                      style: TextStyle(
                          color: ColorConstant.greyTextColor,
                          fontSize: ScreenUtil().setSp(26)),
                      textAlign: TextAlign.center)),
              Expanded(
                  child: Text(widget.myCommission.date,
                      style: TextStyle(
                          color: ColorConstant.greyTextColor,
                          fontSize: ScreenUtil().setSp(26)),
                      textAlign: TextAlign.center)),
            ],
          ),
        ),
        onTap: () {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
