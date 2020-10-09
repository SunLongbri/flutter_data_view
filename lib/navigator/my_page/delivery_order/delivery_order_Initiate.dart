import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import '../../../service/API.dart';
import '../../../service/service_method.dart';
import 'model/delivery_order_model.dart';
import 'dart:convert' as convert;

class DeliveryOrderReceiveOrInitiate extends StatefulWidget {
  final String receiveOrInitiate;//receive接收，initiate发送
  DeliveryOrderReceiveOrInitiate({Key key, this.receiveOrInitiate}):super(key:key);
  @override
  _DeliveryOrderReceiveOrInitiateState createState() => _DeliveryOrderReceiveOrInitiateState();
}

class _DeliveryOrderReceiveOrInitiateState extends State<DeliveryOrderReceiveOrInitiate> {
  List<DeliveryOrderData> _deliveryOrderList;
  String _receiveOrInitiate;
  String flag;//待交接1 已接收2 默认1
  String _stor = '';//筛选门店 北京安贞门, 北京西直门, 北京新发地
  String _startTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String _endTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String _deliveryOrderReceiver = '';//接收人
  @override
  void initState() {
    // TODO: implement initState
    _receiveOrInitiate = JumpReceive().receive(widget.receiveOrInitiate);
    super.initState();
    _deliveryOrderList = [];
    flag = '1';
    _initGoodsList();

  }

//获取交接单列表
  void _initGoodsList() {
    _deliveryOrderList.clear();
    //receive接收，initiate发送
    // flag,//待交接1 已接收2 默认1
    String type = '';
    if (flag=='1'&&_receiveOrInitiate=='receive') {
      type = '1';
    } else if (flag=='1'&&_receiveOrInitiate=='initiate'){
      type = '3';
    }else if (flag=='2'&&_receiveOrInitiate=='receive'){
      type = '2';
    }else if (flag=='2'&&_receiveOrInitiate=='initiate'){
      type = '4';
    }
    var formData = {
      'name':GlobalData.prefs.getString('user_name'),
      'createuser': _receiveOrInitiate=='initiate' ? _deliveryOrderReceiver : '',//发起人
      'responser':_receiveOrInitiate=='receive' ? _deliveryOrderReceiver : '',//接收人
      'type':type,
      'store':_stor,
      'date_start':_startTime,
      'date_end':_endTime
    };
    print('请求数据参数----------$formData');
    postRequest(API.Driver_GetDelivery, formData).then((val) {
      // print('val:${val}');
      DeliveryOrderModel deliveryOrderModel = DeliveryOrderModel.fromJson(val);
      if (deliveryOrderModel.code == GlobalData.REQUEST_SUCCESS) {
        for (DeliveryOrderData data in deliveryOrderModel.data) {
          _deliveryOrderList.add(data);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: _receiveOrInitiate == 'receive' ? '我收到的交接单': '我发起的交接单',
      ),
      body:Container(
        child: Column(
          children: <Widget>[
            SingleSelectIndicatorWidget(
              listContent: ['待交接', '已接收'],
              stringBlock: (selectContent) {
                print('第二选项用户选择的为:${selectContent}');
                if (selectContent == '待交接') {
                  setState(() {
                    flag = '1';
                  });
                  _initGoodsList();
                } else if (selectContent == '已接收') {
                  setState(() {
                    flag = '2';
                  });
                  _initGoodsList();
                } 
              },
            ),
            Container(
              margin: EdgeInsets.all(5),
              width: 375,
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black)
              ),
              child:FlatButton(
                onPressed: (){
                  JumpReceive().jump(context, Routes.deliveryOrderFilterPage).then((value){
                    print(value);
                    Map map = convert.json.decode(value);
                    setState(() {
                      _deliveryOrderReceiver = map['name'];
                      _startTime = map['startTime'];
                      _endTime = map['endTime'];
                      _stor = map['selectedItemList'];
                    });
                    _initGoodsList();
                  });
                }, 
                child: Text('筛选')
              ),
            ),
            SizedBox(height: 3,),
            Expanded(
              child:ListView.builder(
                itemCount: _deliveryOrderList.length,
                itemBuilder: _listItemBuilder,
              )
            ),
          ],
        ),
      )
    );
  }

  //送件到门店
  Widget _listItemBuilder(BuildContext context, int index) {
    DeliveryOrderData orderModel = _deliveryOrderList[index];
    String deliveryOrderProcess = orderModel.source;
    String deliveryOrderSponsor = orderModel.createuser;
    String deliveryOrderReceiver = orderModel.responser;
    String deliveryOrderGoodsNum = orderModel.count;
    String deliveryOrderOverGoodsNum = orderModel.receivedCount;
    String deliveryOrderSendTime = orderModel.createdate;
    String deliveryOrderreceiveTime = orderModel.deliveryDate;
    return InkWell(
      child:Container(
        margin: EdgeInsets.only(left: 5, right: 5,bottom: 10),
        padding: EdgeInsets.all( 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1,
          )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('交接流程：$deliveryOrderProcess'),
            SizedBox(height: 3,),
            Text('发  起  人：$deliveryOrderSponsor'),
            SizedBox(height: 3,),
            Text('接  收  人：$deliveryOrderReceiver'),
            SizedBox(height: 3,),
            Text('交接件数：$deliveryOrderGoodsNum'),
            flag == '1' ? Container() : SizedBox(height: 3,),
            flag == '1' ? Container() : Text('已接收件数：$deliveryOrderOverGoodsNum'),
            SizedBox(height: 3,),
            Text('交接状态：' + (flag == '1' ? '待交接' : '已接收')),
            SizedBox(height: 3,),
            Text('发起时间：$deliveryOrderSendTime'),
            flag == '1' ? Container() : SizedBox(height: 3,),
            flag == '1' ? Container() : Text('交接时间：$deliveryOrderreceiveTime'),
          ],
        ),
      ),
      onTap: (){
        //receive接收，initiate发送
        if (_receiveOrInitiate=='receive') {
          // flag,//待交接1 已接收2 默认1
          if (flag == '1') {
            if (orderModel.source=='门店至干线') {
              //我收到的交接单 待接收 门店至干线
              JumpReceive().jump(context, Routes.deliveryOrderDetailReceiveStoreNotReceivedPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            } else {
              //我收到的交接单 待接收 工厂至干线
              JumpReceive().jump(context, Routes.deliveryOrderDetailReceiveFactoryNotReveivedPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            }
          }else {
            //我收到的交接单 已交接 门店至干线
            if (orderModel.source=='门店至干线') {
              JumpReceive().jump(context, Routes.deliveryOrderDetailReceiveStoreHandedOverPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            } else {
              //我收到的交接单 已交接 工厂至干线
              JumpReceive().jump(context, Routes.deliveryOrderDetailReceiveFactoryHandedOverPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            }
          }
        } else {
          if (flag == '1') {
            if (orderModel.source=='干线到门店') {
              //我发起的交接单 待交接 干线到门店
              JumpReceive().jump(context, Routes.deliveryOrderDetailInitiateStoreNotReceivedPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            } else {
              //我发起的交接单 待交接 干线到工厂
              JumpReceive().jump(context, Routes.deliveryOrderDetailInitiateFactoryNotReceivedPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            }
          }else {
            if (orderModel.source=='干线到门店') {
              //我发起的交接单 已交接 干线到门店
              JumpReceive().jump(context, Routes.deliveryOrderDetailInitiateStoreHandedOverPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            } else {
              //我发起的交接单 已交接 干线到工厂
              JumpReceive().jump(context, Routes.deliveryOrderDetailInitiateFactoryHandedOverPage,paramsName: "deliveryOrderModelString",sendData: json.encode(orderModel));
            }
          }
        }
        
      },
    );
  }

}