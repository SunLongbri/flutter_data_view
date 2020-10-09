import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/order_list_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

//单个订单组件
class SingleOrderWidget extends StatefulWidget {
  final OrderDetailList orderDetail;
  final VoidCallback editAddressTap; //修改地址点击事件
  final VoidCallback markTap; //备注点击事件
  final VoidCallback telTap;

  const SingleOrderWidget(
      {Key key,
      this.orderDetail,
      this.editAddressTap,
      this.markTap,
      this.telTap})
      : super(key: key); //拨号点击事件
  @override
  _SingleOrderWidgetState createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  Color orderTextColor; //订单文字颜色
  List<String> orderType = []; //订单的类型
  OrderDetailList _orderDetail;

  @override
  void initState() {
    _orderDetail = widget.orderDetail;
    orderType = widget.orderDetail.orderWeight;
    if (orderType.contains('超时')) {
      orderTextColor = Color(0xffFD5050);
    } else if (orderType.contains('包月')) {
      orderTextColor = Color(0xff00CDB1);
    } else if (orderType.contains('首单')) {
      orderTextColor = Color(0xff23C3FF);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider _dataProvider = Provider.of<DataProvider>(context);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WashingDetailPage(
                  washingId: _orderDetail.orderId,
                )));
      },
      child: Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(18)),
        child: Column(
          children: <Widget>[
            _orderTitleWidget(_orderDetail.orderId, _orderDetail.orderWeight),
            _orderMarkWidget(
                _orderDetail.customerMark, _orderDetail.deliverMark),
            _orderAddressWidget(
                _orderDetail.placeOrderTime,
                _orderDetail.orderPrice,
                _orderDetail.orderStartAddress,
                _orderDetail.orderEndAddress),
            Container(
              color: Color(0xffEFEFEF),
              height: AutoLayout.instance.pxToDp(2),
            ),
            _operateBtnWidget(_orderDetail.orderSource),
          ],
        ),
      ),
    );
  }

  //操作按钮组件
  Widget _operateBtnWidget(String orderSource) {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(22)),
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(6)),
                child: Image.asset(
                  'images/order_source_icon.png',
                  width: ScreenUtil().setWidth(36),
                ),
              ),
              Text(
                orderSource,
                style: TextStyle(
                    color: Color(0xffC4C4C4), fontSize: ScreenUtil().setSp(30)),
              )
            ],
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              _btnWidget('修改地址', _editAddressTap),
//              _btnWidget('备注', _markTap, type: 1),
//              _btnWidget('拨号', _telTap, type: 1),
//            ],
//          )
        ],
      ),
    );
  }

  //修改地址按钮
  void _editAddressTap() {
    showToast('修改按钮... ');
  }

  //添加备注按钮
  void _markTap() {
    showToast('备注按钮... ');
  }

  //拨号按钮
  void _telTap() {
    showToast('拨号按钮... ');
  }

  //按钮组件
  Widget _btnWidget(String text, VoidCallback tap, {int type = 0}) {
    return Container(
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
      height: AutoLayout.instance.pxToDp(52),
      width: type == 0 ? null : ScreenUtil().setWidth(120),
      child: FlatButton(
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff50B8FB), width: 1),
            borderRadius: BorderRadius.circular(200),
          ),
          onPressed: tap,
          child: Text(
            text,
            style: TextStyle(
                color: Color(0xff4EB9FB), fontSize: ScreenUtil().setSp(25)),
          )),
    );
  }

  //订单地址组件
  Widget _orderAddressWidget(String orderTime, String price,
      String orderStartAddress, String orderEndAddress) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(10),
          right: ScreenUtil().setWidth(20)),
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(170),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _titleTextWidget('下单时间：', ColorConstant.greyTextColor),
                  _titleTextWidget(
                      orderTime, ColorConstant.greyTextColor),
                ],
              ),
              _titleTextWidget('¥${37.7}', ColorConstant.blackTextColor),
            ],
          ),
          _addressWidget('images/order_address_start.png', orderStartAddress),
          _addressWidget('images/order_address_end.png', orderEndAddress),
        ],
      ),
    );
  }

  //地址组件
  Widget _addressWidget(String icon, String address) {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(12)),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(38),
            child: Image.asset(icon),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
            child: _titleTextWidget(address, ColorConstant.greyTextColor),
          )
        ],
      ),
    );
  }

  //订单留言组件
  Widget _orderMarkWidget(String customerMark, String deliverMark) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
      color: Color(0xffF9F9F9),
      height: AutoLayout.instance.pxToDp(126),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              _titleTextWidget('客户备注:', ColorConstant.greyTextColor),
              _titleTextWidget(customerMark, ColorConstant.greyTextColor),
            ],
          ),
          Row(
            children: <Widget>[
              _titleTextWidget('小哥备注:', ColorConstant.greyTextColor),
              _titleTextWidget(deliverMark, ColorConstant.greyTextColor),
            ],
          ),
        ],
      ),
    );
  }

  //订单头部组件
  Widget _orderTitleWidget(String orderCode, List<String> orderWeight) {
    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(82),
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(18)),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(6)),
            width: ScreenUtil().setWidth(40),
            child: Image.asset('images/order_icon.png'),
          ),
          _titleTextWidget('订单编号:', orderTextColor),
          _titleTextWidget(orderCode, orderTextColor),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
            child: Row(
              children: <Widget>[
                orderWeight.contains('首单')
                    ? _titleIconWidget('images/order_weight_first.png')
                    : Container(),
                orderWeight.contains('超时')
                    ? _titleIconWidget('images/order_weight_overtime.png')
                    : Container(),
                orderWeight.contains('包月')
                    ? _titleIconWidget('images/order_weight_month.png')
                    : Container(),
              ],
            ),
          )),
          _titleTextWidget(widget.orderDetail.orderType, Color(0xff999999)),
        ],
      ),
    );
  }

  Widget _titleIconWidget(String imageAssets) {
    return Container(
      width: ScreenUtil().setWidth(42),
      child: Image.asset(imageAssets),
    );
  }

  Widget _titleTextWidget(String content, Color textColor) {
    return Container(
      child: Text(
        content,
        style: TextStyle(color: textColor, fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }
}
