import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';

class DeliveryOrderPage extends StatefulWidget {
  @override
  _DeliveryOrderPageState createState() => _DeliveryOrderPageState();
}

class _DeliveryOrderPageState extends State<DeliveryOrderPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarWidget(
        title: '交接单',
      ),
      body: Stack (
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            left: 30,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.yellow,
              ),
              height: 100,
              width: 140,
              // color: Colors.yellow,
              child: FlatButton(onPressed: (){
                JumpReceive().jump(context, Routes.deliveryOrderReceiveOrInitiatePage,paramsName: 'data', sendData: 'initiate');
              }, child: Text('我发起的交接单') ),
            )
          ),
          Positioned(
            right: 30,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.red,
              ),
              height: 100,
              width: 140,
              // color: Colors.red,
              child: FlatButton(onPressed: (){
                JumpReceive().jump(context, Routes.deliveryOrderReceiveOrInitiatePage,paramsName: 'data', sendData: 'receive');
              }, child: Text('我收到的交接单') ),
            )
          ),
          Positioned(
            top: 200,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.green
              ),
              height: 100,
              width: 150,
              // color: Colors.green,
              child: FlatButton(onPressed: (){
                JumpReceive().jump(context, Routes.deliveryOrderCreatePage);
              }, child: Text('创建交接单') ),
            )
          ),
        ],
      ),
    );
  }
}