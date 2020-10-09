import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/model/delivery_order_good_model.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:provider/provider.dart';

import '../../../../constant/global_data.dart';
import '../../../../provider/data_provider.dart';

class DeliveryOrderListView extends StatefulWidget {
  final String deliveryProcess;//交接流程 到工厂或者到门店
  final String from;//来源 创建订单create 或者 其他other
  final String deliveryId;//交接单id
  const DeliveryOrderListView({Key key, this.deliveryProcess, this.from, this.deliveryId}):super(key: key);

  @override
  _DeliveryOrderListViewState createState() => _DeliveryOrderListViewState();
}

class _DeliveryOrderListViewState extends State<DeliveryOrderListView> {
  List<OrderGoodModel> _orderGoodList;
  List<StoreGoodModel> _storeGoodList;
  String _deliveryProcess;
  String _from;
  String _deliveryId;
  DataProvider _dataProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderGoodList = [];
    _storeGoodList = [];
    _deliveryProcess = widget.deliveryProcess;
    _from = widget.from;
    _deliveryId = widget.deliveryId;
    _initGoodsList();
  }

  //获取商品列表
  void _initGoodsList() {
    Map<String, String> queryParameters = {'delivery_order_id': _deliveryId};
    getRequest(API.Driver_DeliveryDetail, queryParameters: queryParameters).then((val) {
      print('val:${val}');
      // if (_deliveryProcess == '干线到工厂') {
      //   DeliveryOrderDetailModel deliveryOrderDetailModel = DeliveryOrderDetailModel.fromJson(val);
      //   if (deliveryOrderDetailModel.code == GlobalData.REQUEST_SUCCESS) {
      //     print(deliveryOrderDetailModel.data);
      //     for (StoreGoodModel orderGoodModel in deliveryOrderDetailModel.data) {
      //       for (var goodsModel in orderGoodModel.typeGoodsList) {
      //         for (var goods in goodsModel.goodsList) {
      //           goods.isSelect = _from=='create'?'1':'0';
      //         }
      //       }
      //       _storeGoodList.add(orderGoodModel);
      //       setState(() {
              
      //       });
      //     }
      //   }
      // }else{
        OrderGoodDetailModel orderGoodDetailModel = OrderGoodDetailModel.fromJson(val);
        if (orderGoodDetailModel.code == GlobalData.REQUEST_SUCCESS) {
          print(orderGoodDetailModel.data);
          for (OrderGoodModel orderGoodModel in orderGoodDetailModel.data) {
            for (var goodsModel in orderGoodModel.goodsList) {
              goodsModel.isSelect = _from=='create'?'1':'0';
            }
            _orderGoodList.add(orderGoodModel);
            setState(() {
              
            });
          }
        }
      // }
      //   )
    });

  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Column(
      children: (_deliveryProcess == '干线到工厂' 
      ? _storeGoodList.map(_listStoreItemBuilder).toList() 
      : _orderGoodList.map(_listItemBuilder).toList()
      ),

    );
  }
 //送件到门店
  Widget _listItemBuilder(OrderGoodModel orderModel) {      
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          color: ColorConstant.greyLineColor,
          width: 0.5,
        ))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 375,
            child: _storeTitle(orderModel)
          )
        ],
      ),
    );
  }
  //送件到工厂
  Widget _listStoreItemBuilder(StoreGoodModel storeModel) {      
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          color: ColorConstant.greyLineColor,
          width: 0.5,
        ))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 375,
            child: ExpansionTile(
              // key: PageStorageKey<StoreGoodModel>(storeModel),
              title: Text('送件门店:'+storeModel.storeName), 
              initiallyExpanded: false,
              children:storeModel.typeGoodsList.map(_storeTitle).toList(),
            )
          )
        ],
      ),
    );
  }


  Widget _storeTitle(OrderGoodModel orderModel){
    return ExpansionTile(
      key: PageStorageKey<OrderGoodModel>(orderModel),
      title: _orderTitleAndCount(orderModel), 
      initiallyExpanded: false,
      children:orderModel.goodsList.map(_goodsInfoWidget).toList(),
    );
  }


  //订单标题和数量
  Widget _orderTitleAndCount(OrderGoodModel model){
    int goodNum = model.goodsList.length;
    int selectGoodNum = 0;
    for (var goodsModel in model.goodsList) {
      if (goodsModel.isSelect == '1') {
        selectGoodNum += 1;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text((_deliveryProcess == '干线到工厂' ? '' : '订单编号：')+model.orderId, style: TextStyle(fontSize: 14),),
        Text('($selectGoodNum/$goodNum)', style: TextStyle(fontSize: 14)),
      ],
    );
  }
  

    //商品信息组件
  Widget _goodsInfoWidget(DeliveryOrderGoodModel model) {
    if (model.goodsMark == _dataProvider.sacnCode) {
      model.isSelect = '1';
    }
    return Container(
      margin: EdgeInsets.only(left: 15),
      height: 60,
      width: 375,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConstant.greyLineColor, width: 1))
      ),
      child: Stack(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      //商品编码
                      model.markCode,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      //商品名称
                      model.goodsName,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    //备注
                    model.goodsMark != null ? model.goodsMark : '',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            model.isSelect == '1' ? Container(
              child:_selectImgWidget('images/tab_push_select.png', 76, 76),
              ) : Container()
          ],
        ),
        
        Positioned(
          child: MaterialButton(
            onPressed: (){
              model.isSelect = model.isSelect == '1' ? '0' : '1';
              setState(() {
                // model = model;
                
              });
            }
          ),
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
        )
      ],)
      
    );
  }

  //图片组件
  _selectImgWidget(String image, int width, double height) {
    return Container(
      width: width / 2,
      height: height / 2,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}

