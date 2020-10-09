import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/model/delivery_order_model.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/view/delivery_order_listview.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert' as convert;

import '../../../../routers/routes.dart';

//我发起的交接单 待交接 干线到门店
class DeliveryOrderDetailInitiateStoreNotReceived extends StatefulWidget {
  String deliveryOrderModelString;//交接单model
  DeliveryOrderDetailInitiateStoreNotReceived({Key key,this.deliveryOrderModelString}):super(key:key);
  @override
  _DeliveryOrderDetailInitiateStoreNotReceivedState createState() => _DeliveryOrderDetailInitiateStoreNotReceivedState();
}

class _DeliveryOrderDetailInitiateStoreNotReceivedState extends State<DeliveryOrderDetailInitiateStoreNotReceived> {
  
  DeliveryOrderData _deliveryOrderModel;//交接单model
  String _receiveOrInitiate;
  
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
              _rowLine('交接总件数', _deliveryOrderModel.count),
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
        bottomNavigationBar: Container(
          // decoration: BoxDecoration(
          //   border: Border.all(color: Color(0xffABABAB), width: 1),
          //   color: Colors.white,
          // ),
          height: 40.0,
          child: _bottomNavigationContainer()
        )
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

  Widget _bottomNavigationContainer(){
    return Container(
      // margin: EdgeInsets.all(5),
      child: OutlineButton(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        highlightedBorderColor: Theme.of(context).primaryColor,
        disabledBorderColor: Theme.of(context).primaryColor,
        highlightColor: Colors.pink[100],
        onPressed: () {
          print('取消交接单');
          
        },
        child: Container(
          child: Text('取消交接单'),
        )
      ),
    );
  }
  
}