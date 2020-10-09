import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/order_list_model.dart';
import 'package:fluttermarketingplus/model/order_str_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/home_amap_widgets/single_order_widget.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//订单列表页面
class OrderListPage extends StatefulWidget {
  final String orderStr;

  const OrderListPage({Key key, this.orderStr}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<String> orderList = [];
  List<OrderDetailList> _orderDetailList = [];
  String _startTime; //日期开始时间
  String _endTime; //日期结束时间
  String _orderState; //订单状态
  String _sortImage; //时间排序图标
  bool _isLoading;
  List<String> orderDataList; //订单总列表
  RefreshController _refreshController;
  int page = 0; //当前页数

  @override
  void initState() {
    page = 1;
    _isLoading = false;
    _sortImage = 'images/sort_up.png'; //正序图标
    _refreshController = RefreshController(initialRefresh: false);
    DateTime _time = DateTime.now();
    String _currentTime = '${_time.year}-${_time.month}-${_time.day}';
    _startTime = _currentTime;
    _endTime = _currentTime;
    if (widget.orderStr != null) {
      orderList = widget.orderStr.split(',');
      orderDataList = [];
      for (int i = 0; i < orderList.length; i++) {
        if (orderList[i].isNotEmpty) {
          orderDataList.add(orderList[i]);
        }
      }
      print('订单列表:${orderDataList.toString()}');
      _getOrderListFromOrderStr(orderDataList);
    }
    super.initState();
  }

  //根据订单数组，获取订单列表
  _getOrderListFromOrderStr(List<String> orderListStr, {bool noData = false}) {
    if (orderListStr.length > 10) {
      orderListStr = orderListStr.sublist(0, 10);
    }
    var formData = {"orderList": orderListStr};
    setState(() {
      _isLoading = true;
    });
    postRequest(API.ORDER_LIST, formData, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      print('订单列表formData:${formData}');
      print('订单列表返回结果:${value}');
      OrderListModel orderListModel = OrderListModel.fromJson(value);
      _dataProvider.isRefresh = false;
      if (orderListModel.code == 200) {
        if (noData) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }

        _refreshController.refreshCompleted();
        //数据正常返回
        List<OrderDetailList> orderDetailList = orderListModel.orderDetailList;
        setState(() {
          //记录初始订单状态
//          if (orderDetailList.isNotEmpty && _orderState == null) {
//            _orderState = orderDetailList[0].orderType;
//          }

          if (orderDetailList.isEmpty) {
            showToast('没有数据!');
          }

          for (int i = 0; i < orderDetailList.length; i++) {
            if ((_dataProvider?.getOrderState ?? '').isEmpty) {
              _orderDetailList.add(orderDetailList[i]);
            } else {
              if (orderDetailList[i].orderType ==
                  _dataProvider?.getOrderState) {
                _orderDetailList.add(orderDetailList[i]);
              }
            }
          }
        });
      }
    });
  }

  DataProvider _dataProvider;

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    if(_dataProvider.isRefresh){
      page = 1;
      _orderDetailList.clear();
      _getOrderListFromOrderStr(orderDataList);
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: '查看订单',
      ),
      body: Container(
        child: LoadingContainer(
          isLoading: _isLoading,
          cover: true,
          child: Column(
            children: <Widget>[
              Container(
                height: AutoLayout.instance.pxToDp(100),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _singleDataWidget(_startTime, () {
                      DatePicker.showDatePicker(context,
                          onConfirm: (DateTime time, List<int> positionList) {
                        print('用户选择的时间为:${time},list:${positionList}');
                        setState(() {
                          _startTime = time.toString().split(' ')[0];
                        });
                      });
                    }),
                    _lineWidget(),
                    _singleDataWidget(_endTime, () {
                      DatePicker.showDatePicker(context,
                          onConfirm: (DateTime time, List<int> positionList) {
                        print('用户选择的时间为:${time},list:${positionList}');
                        setState(() {
                          _endTime = time.toString().split(' ')[0];
                        });
                      });
                    }),
                    _searchBtn()
                  ],
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  bool _sort = true;
                  setState(() {
                    if (_sortImage.contains('up')) {
                      _sortImage = 'images/sort_down.png';
                      _sort = false;
                    } else {
                      _sortImage = 'images/sort_up.png';
                      _sort = true;
                    }
                  });
                  var formData = {"orderType": _orderState, "sort": _sort};
                  setState(() {
                    _isLoading = true;
                  });
                  postRequest(API.SORT_ORDER, formData,
                          tempBaseUrl: API.TEST_BASE_URL)
                      .then((value) {
                    setState(() {
                      _isLoading = false;
                    });
                    print('时间排序返回:${value}');
                    OrderStrModel _orderStrModel =
                        OrderStrModel.fromJson(value);
                    if (_orderStrModel.code == 200) {
                      List<String> _orderListStr = _orderStrModel.data.sortList;
                      _orderDetailList.clear();
                      _getOrderListFromOrderStr(_orderListStr);
                    }
                  });
                },
                child: Container(
                  height: AutoLayout.instance.pxToDp(66),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(42)),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '下单时间',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: ColorConstant.blueTextColor),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(22),
                        child: Image.asset(
                          _sortImage,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _orderDetailList.isEmpty
                    ? Container()
                    : SmartRefresher(
                        controller: _refreshController,
                        enablePullUp: true,
                        enablePullDown: true,
                        header: WaterDropHeader(),
                        onRefresh: () {
                          page = 1;
                          _orderDetailList.clear();
                          _getOrderListFromOrderStr(orderDataList);
                        },
                        onLoading: () {
                          _loadMoreData(orderDataList);
                        },
                        child: ListView.builder(
                            itemCount: _orderDetailList.length,
                            itemBuilder: (BuildContext context, int position) {
                              return SingleOrderWidget(
                                orderDetail: _orderDetailList[position],
                              );
                            }),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //加载更多数据
  _loadMoreData(List<String> orderListStr) {
    bool noData;
    if (orderListStr.length < 10) {
      _refreshController.loadNoData();
      return;
    } else if (orderListStr.length > ((page + 1) * 10)) {
      orderListStr = orderListStr.sublist(page * 10, (page + 1) * 10);
      noData = false;
    } else {
      orderListStr = orderListStr.sublist(page * 10, orderListStr.length);
      noData = true;
    }
    _getOrderListFromOrderStr(orderListStr, noData: noData);
    page++;
  }

  Widget _searchBtn() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        var formData = {
          "orderType": _orderState,
          "sortFromType": {"startTime": _startTime, "endTime": _endTime}
        };
        setState(() {
          _isLoading = true;
        });
        postRequest(API.SORT_ORDER, formData, tempBaseUrl: API.TEST_BASE_URL)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
          print('时间排序参数:${formData}');
          print('时间排序返回:${value}');
          OrderStrModel _orderStrModel = OrderStrModel.fromJson(value);
          if (_orderStrModel.code == 200) {
            _orderDetailList.clear();
            List<String> _orderListStr = _orderStrModel.data.sortList;
            _getOrderListFromOrderStr(_orderListStr);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(120),
        height: AutoLayout.instance.pxToDp(48),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: ColorConstant.blueTextColor),
        child: Text(
          '查询',
          style:
              TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.white),
        ),
      ),
    );
  }

  Widget _lineWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(6), right: ScreenUtil().setWidth(6)),
      width: ScreenUtil().setWidth(26),
      height: AutoLayout.instance.pxToDp(1),
      color: ColorConstant.blueTextColor,
    );
  }

  Widget _singleDataWidget(String selectTime, VoidCallback onTap) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: AutoLayout.instance.pxToDp(54),
        width: ScreenUtil().setWidth(238),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: ColorConstant.blueTextColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              selectTime,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: ColorConstant.blueTextColor),
            ),
            Container(
              width: ScreenUtil().setWidth(28),
              child: Image.asset(
                'images/arrow_blue_down.png',
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
    );
  }
}
