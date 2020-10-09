import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/model/delivery_order_model.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/view/delivery_order_listview.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';

import 'dart:convert' as convert;

//我收到的交接单 已交接 工厂至干线
class DeliveryOrderDetailReceiveFactoryHandedOver extends StatefulWidget {
  String deliveryOrderModelString;//交接单model
  DeliveryOrderDetailReceiveFactoryHandedOver({Key key,this.deliveryOrderModelString}):super(key:key);
  @override
  _DeliveryOrderDetailReceiveFactoryHandedOverState createState() => _DeliveryOrderDetailReceiveFactoryHandedOverState();
}

class _DeliveryOrderDetailReceiveFactoryHandedOverState extends State<DeliveryOrderDetailReceiveFactoryHandedOver> {
  
  DeliveryOrderData _deliveryOrderModel;//交接单model
  
  @override
  void initState() {
    var dic = convert.jsonDecode(JumpReceive().receive(widget.deliveryOrderModelString));
    _deliveryOrderModel = DeliveryOrderData.fromJson(dic);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '交接单详情',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _titleWidget('交接信息', false),
              _rowLine('交接流程', _deliveryOrderModel.source),
              _rowLine('发起人', _deliveryOrderModel.createuser),
              _rowLine('接收人', _deliveryOrderModel.responser),
              _rowLine('发起时间', _deliveryOrderModel.createdate),
              _rowLine('接收时间', _deliveryOrderModel.deliveryDate),
              _rowLine('交接总件数', _deliveryOrderModel.count),
              _rowLine('已交接件数', _deliveryOrderModel.receivedCount),
              _rowLine('交接状态',_deliveryOrderModel.status),
              SizedBox(
                height: 10,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              _titleWidget('交接商品', false),
              DeliveryOrderListView(deliveryProcess: _deliveryOrderModel.source,from: 'other',deliveryId: _deliveryOrderModel.deliveryOrderId,) 
            ],
          ),
        ),
      );
  }

  //标题
  Widget _titleWidget(String title, bool isShowClearButton) {
    return Container(
      height: AutoLayout.instance.pxToDp(80),
      margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(12), left: ScreenUtil().setWidth(12)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: ColorConstant.blackTextColor,
                fontSize: ScreenUtil().setSp(40)),
          ),
          isShowClearButton
              ? Container(
                  margin: EdgeInsets.all(5),
                  child: OutlineButton(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      highlightedBorderColor: Theme.of(context).primaryColor,
                      disabledBorderColor: Theme.of(context).primaryColor,
                      highlightColor: Colors.pink[100],
                      onPressed: () {},
                      child: Container(
                        child: Text('清空'),
                      )),
                )
              : Container()
        ],
      ),
    );
  }

  //单行样式
  Widget _rowLine(String text, String name) {
    return Container(
      height: AutoLayout.instance.pxToDp(98),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(28),
        right: ScreenUtil().setWidth(28),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            width: AutoLayout.instance.pxToDp(150),
            child: Text(
              text,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(420),
            child: Text(
              name,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          )
        ],
      ),
    );
  }  
}