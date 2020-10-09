import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/all_order_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/home_amap_page/order_list_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/search_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'all_order_widgets/single_line_widget.dart';

//全部订单页面
class AllOrderPage extends StatefulWidget {
  @override
  _AllOrderPageState createState() => _AllOrderPageState();
}

class _AllOrderPageState extends State<AllOrderPage> {
  String _tabKey;
  bool _loading;
  AllOrderModel allOrderModel; //全部订单
  DataProvider _dataProvider;

  @override
  void initState() {
    _tabKey = '洗涤';
    _loading = false;
    _initData();
    super.initState();
  }

  _initData() {
    getRequest(API.ALL_WASHING_LIST, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      _dataProvider.isRefresh = false;
      print('value:${value}');
      allOrderModel = AllOrderModel.fromJson(value);
      if (allOrderModel.code == 200) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    if (_dataProvider.isRefresh) {
      _initData();
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: '全部订单',
        actionsWidget: Container(
          width: ScreenUtil().setWidth(44),
          child: Image.asset(
            'images/search_bar_icon.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        actionPress: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _loading,
        child: Column(
          children: <Widget>[
            _tabBarWidget(),
            _tabContentWidget(),
          ],
        ),
      ),
    );
  }

  Widget _tabContentWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      child: Column(
        children: <Widget>[
          SingleLineWidget(
            orderState: '未受理',
            orderCount:
                '${allOrderModel?.data?.orderNotAcceptedData?.length ?? ''}',
            callback: () {
              String orderStr = '';
              List<String> notAcceptList =
                  allOrderModel?.data?.orderNotAcceptedData ?? [];
              if (notAcceptList.isNotEmpty ?? false) {
                for (int i = 0; i < notAcceptList.length; i++) {
                  orderStr = orderStr + notAcceptList[i] + ',';
                }
                _dataProvider.setOrderState = '未受理';
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderListPage(
                          orderStr: orderStr,
                        )));
              }
            },
          ),
          SingleLineWidget(
            orderState: '已受理',
            orderCount:
                '${allOrderModel?.data?.orderAcceptedData?.length ?? ''}',
            callback: () {
              String orderStr = '';
              List<String> orderAcceptList =
                  allOrderModel?.data?.orderAcceptedData ?? [];
              if (orderAcceptList.isNotEmpty ?? false) {
                for (int i = 0; i < orderAcceptList.length; i++) {
                  orderStr = orderStr + orderAcceptList[i] + ',';
                }
                _dataProvider.setOrderState = '已受理';
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderListPage(
                          orderStr: orderStr,
                        )));
              }
            },
          ),
          SingleLineWidget(
            orderState: '已取件',
            orderCount: '${allOrderModel?.data?.alreadyGetOrder?.length ?? ''}',
            callback: () {
              String orderStr = '';
              List<String> alreadyGetOrder =
                  allOrderModel?.data?.alreadyGetOrder ?? [];
              if (alreadyGetOrder.isNotEmpty ?? false) {
                for (int i = 0; i < alreadyGetOrder.length; i++) {
                  orderStr = orderStr + alreadyGetOrder[i] + ',';
                }
                _dataProvider.setOrderState = '已取件';
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderListPage(
                          orderStr: orderStr,
                        )));
              }
            },
          ),
          SingleLineWidget(
            orderState: '派送中',
            orderCount:
                '${allOrderModel?.data?.orderInProgressData?.length ?? ''}',
            callback: () {
              String orderStr = '';
              List<String> orderInProgressData =
                  allOrderModel?.data?.orderInProgressData ?? [];
              if (orderInProgressData.isNotEmpty ?? false) {
                for (int i = 0; i < orderInProgressData.length; i++) {
                  orderStr = orderStr + orderInProgressData[i] + ',';
                }
                _dataProvider.setOrderState = '派送中';
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderListPage(
                          orderStr: orderStr,
                        )));
              }
            },
          ),
          SingleLineWidget(
            orderState: '已签收',
            orderCount:
                '${allOrderModel?.data?.orderSignedInData?.length ?? ''}',
            callback: () {
              String orderStr = '';
              List<String> orderSignedInData =
                  allOrderModel?.data?.orderSignedInData ?? [];
              if (orderSignedInData.isNotEmpty ?? false) {
                for (int i = 0; i < orderSignedInData.length; i++) {
                  orderStr = orderStr + orderSignedInData[i] + ',';
                }
                _dataProvider.setOrderState = '已签收';
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderListPage(
                          orderStr: orderStr,
                        )));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _tabBarWidget() {
    Color _leftColor = ColorConstant.greyTextColor;
    Color _rightColor = ColorConstant.greyTextColor;
    if (_tabKey == '洗涤') {
      _leftColor = ColorConstant.blueTextColor;
    } else {
      _rightColor = ColorConstant.blueTextColor;
    }
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: AutoLayout.instance.pxToDp(100),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (_tabKey == '洗涤') {
                      print('重复点击  ..... ');
                      return;
                    }
                    setState(() {
                      _tabKey = '洗涤';
                    });
                    print('切换到洗涤页面 .... ');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '洗涤',
                      style: TextStyle(
                          color: _leftColor, fontSize: ScreenUtil().setSp(30)),
                    ),
                  ))),
          Container(
            color: ColorConstant.blueTextColor,
            width: ScreenUtil().setWidth(1),
            height: AutoLayout.instance.pxToDp(32),
          ),
          Expanded(
              child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (_tabKey == '鲜花') {
                print('重复点击  ..... ');
                return;
              }
              setState(() {
                _tabKey = '鲜花';
              });
              print('切换到鲜花页面 .... ');
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '鲜花',
                style: TextStyle(
                    color: _rightColor, fontSize: ScreenUtil().setSp(30)),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
