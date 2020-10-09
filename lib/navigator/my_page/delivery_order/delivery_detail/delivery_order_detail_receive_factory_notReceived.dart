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
//我收到的交接单 待接收 工厂至干线
class DeliveryOrderDetailReceiveFactoryNotReveived extends StatefulWidget {
  String deliveryOrderModelString;//交接单model
  DeliveryOrderDetailReceiveFactoryNotReveived({Key key,this.deliveryOrderModelString}):super(key:key);
  @override
  _DeliveryOrderDetailReceiveFactoryNotReveivedState createState() => _DeliveryOrderDetailReceiveFactoryNotReveivedState();
}

class _DeliveryOrderDetailReceiveFactoryNotReveivedState extends State<DeliveryOrderDetailReceiveFactoryNotReveived> {
  
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
          print('查询');
          startScan(context);
          JumpReceive().jump(context, Routes.deliveryOrderScanQrPage).then(
            (value){
              print('扫码结果》》》》'+value);
            }
          );
        },
        child: Container(
          child: Text('扫码确认'),
        )
      ),
    );
  }

  Future startScan(BuildContext context) async {
    
  requestPermission();
}
 
Future requestPermission() async {
  // 申请权限
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);
 
  // 申请结果
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
}
  
}