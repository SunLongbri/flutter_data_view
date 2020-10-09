import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_widgets/order_card_widget.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'washing_detail_widgets/bottom_widget.dart';
import 'washing_detail_widgets/goods_list_widget.dart';

//洗涤订单详情页面
class WashingDetailPage extends StatefulWidget {
  final String washingId;

  const WashingDetailPage({Key key, this.washingId}) : super(key: key); //订单的id号
  @override
  _WashingDetailPageState createState() => _WashingDetailPageState();
}

class _WashingDetailPageState extends State<WashingDetailPage> {
  WashingDetail _washingDetail;
  String _orderState; //当前订单的状态
  String _goodsPayState; //订单支付状态
  bool _isLoading;
  RefreshController _refreshController;
  DataProvider _dataProvider;
  @override
  void initState() {
    _orderState = '';
    _goodsPayState = '';
    _isLoading = false;
    _refreshController = RefreshController(initialRefresh: false);
    _initOrderData();
    super.initState();
  }

  _initOrderData() {
    var formData = {"orderNumber": widget.washingId};
    setState(() {
      _isLoading = true;
    });
    postRequest(API.GAIN_ORDER_DETAIL, formData, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      setState(() {
        _isLoading = false;
        _refreshController.refreshCompleted();
        _dataProvider.isRefresh = false;
      });
      print('洗涤订单详情:formData:${formData}');
      print('洗涤订单详情:${value}');
      OrderDetailModel _orderDetailModel = OrderDetailModel.fromJson(value);
      if (_orderDetailModel.code == 200) {
        setState(() {
          _washingDetail = _orderDetailModel.data.washingDetail;
          _orderState = _orderDetailModel.data.washingDetail.orderState;
          _goodsPayState = _orderDetailModel.data.washingDetail.goodsPayState;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    if(_dataProvider.isRefresh){
      _initOrderData();
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: '洗涤订单详情',
        backPress: () {
          _dataProvider.setPartSignForState = false;
          _dataProvider.setPartsGoodsList = [];
          Navigator.pop(context);
        },
      ),
      body: LoadingContainer(
        isLoading: _isLoading,
        cover: true,
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: false,
          enablePullDown: true,
          header: WaterDropHeader(),
          onRefresh: (){
            _initOrderData();
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                OrderCardWidget(
                  washingId: widget.washingId,
                  washingDetail: _washingDetail,
                ),
                (_washingDetail?.goodsList ?? []).isNotEmpty
                    ? GoodsListWidget(
                  goodsList: _washingDetail?.goodsList ?? [],
                  goodsTotalPrice: _washingDetail?.goodsTotalPrice ?? .0,
                  goodsPayState: _washingDetail?.goodsPayState ?? '',
                  washingDetail: _washingDetail,
                )
                    : Container()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomWidget(
        orderId: widget.washingId,
        orderState: _orderState,
        goodsPayState: _goodsPayState,
        washingDetail: _washingDetail,
      ),
    );
  }
}
