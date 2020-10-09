import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/utils/next_latlng.dart';

//订单页面
class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with NextLatLng {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text(
          '订单页面',
          style:
              TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25)),
        ),
      ),
    );
  }
}
