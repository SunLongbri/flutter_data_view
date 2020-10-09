import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/model/upload_confirm_order_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/drawing_board_page.dart';
import 'package:provider/provider.dart';

import 'confirm_order_widgets/single_goods_widget.dart';

//确认订单页面
class ConfirmOrderPage extends StatefulWidget {
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  String userName; //客户姓名
  String receivePhone; //客户电话
  String orderEndAddress; //订单送件地址
  DataProvider _dataProvider;
  List<GoodsList> _confirmGoodsList; //商品列表
  double _totalPrice; //订单金额
  bool _isShowBottom;
  String _orderId; //绑定当前衣物的订单号
  List<String> _partsGoodsList; //童装衣物

  @override
  void initState() {
    _isShowBottom = true;
    _totalPrice = 0;
    userName = GlobalData.prefs.getString('user_name');
    receivePhone = GlobalData.prefs.getString('receive_phone');
    orderEndAddress = GlobalData.prefs.getString('order_end_address');
    _confirmGoodsList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    _orderId = _dataProvider.getCurrentBindOrderId;
    _confirmGoodsList = _dataProvider.getConfirmGoodsList;
    _partsGoodsList = _dataProvider.getPartsGoodsList;
    _totalPrice = 0;
    for (int i = 0; i < _confirmGoodsList.length; i++) {
      double singlePrice = 0;
      if (_partsGoodsList.contains(_confirmGoodsList[i].goodsNum)) {
        singlePrice = _confirmGoodsList[i].goodsPrice / 2;
      } else {
        singlePrice = _confirmGoodsList[i].goodsPrice;
      }
      _totalPrice = _totalPrice + singlePrice;
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: '确认订单',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: AutoLayout.instance.pxToDp(20),
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          child: Column(
            children: <Widget>[
              _orderInfoWidget(),
              _confirmGoodsListWidget(_confirmGoodsList),
              _totalPriceWidget(),
              _orderPriceWidget(),
              _isShowBottom ? Container() : _confirmBtn()
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isShowBottom
          ? _bottomBtnWidget()
          : Container(
              color: Colors.transparent,
              height: AutoLayout.instance.pxToDp(92),
              width: ScreenUtil().setWidth(750),
            ),
    );
  }

  //确认标记童装按钮
  Widget _confirmBtn() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(100)),
      child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          color: ColorConstant.blueBgColor,
          onPressed: () {
            setState(() {
              _isShowBottom = true;
            });
            _dataProvider.setPartSignForState = false;
          },
          child: Container(
            alignment: Alignment.center,
            height: AutoLayout.instance.pxToDp(70),
            width: ScreenUtil().setWidth(564),
            child: Text(
              '确认标记',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32), color: Colors.white),
            ),
          )),
    );
  }

  //底部按钮组件
  Widget _bottomBtnWidget() {
    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(92),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                _isShowBottom = false;
              });
              _dataProvider.setPartsGoodsList = [];
              _dataProvider.setPartSignForState = true;
            },
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(38)),
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(174),
              height: AutoLayout.instance.pxToDp(52),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.blueTextColor),
                  borderRadius: BorderRadius.circular(100)),
              child: Text(
                '标记童装',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: ColorConstant.blueTextColor),
              ),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              UploadConfirmOrderModel _uploadConfirmOrderModel =
                  UploadConfirmOrderModel();
              _uploadConfirmOrderModel.orderNumber = _orderId;
              _uploadConfirmOrderModel.receiveName = userName;
              _uploadConfirmOrderModel.receivePhone = receivePhone;
              _uploadConfirmOrderModel.receiveAddress = orderEndAddress;

              List<SingleGoods> _uploadSingleGoodsList = [];
              for (int i = 0; i < _confirmGoodsList.length; i++) {
                SingleGoods singleGoods = SingleGoods();
                singleGoods.goodsName = _confirmGoodsList[i].goodsName;
                singleGoods.goodsCode = _confirmGoodsList[i].goodsNum;
                singleGoods.goodsParts = _confirmGoodsList[i].goodsParts;
                singleGoods.goodsMark = _confirmGoodsList[i].goodsFlawMark;
                singleGoods.id = _confirmGoodsList[i].id;

                if (_partsGoodsList.contains(_confirmGoodsList[i].goodsNum)) {
                  singleGoods.goodsPrice = _confirmGoodsList[i].goodsPrice / 2;
                  singleGoods.isChildrenType = true;
                } else {
                  singleGoods.goodsPrice = _confirmGoodsList[i].goodsPrice;
                  singleGoods.isChildrenType = false;
                }
                _uploadSingleGoodsList.add(singleGoods);
              }
              _uploadConfirmOrderModel.goodsList = _uploadSingleGoodsList;
              _uploadConfirmOrderModel.totalPrice = _totalPrice;

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DrawingBoardPage(
                        orderId: _orderId,
                        allCount: _confirmGoodsList.length,
                        uploadConfirmOrderModel: _uploadConfirmOrderModel,
                      )));
            },
            child: Container(
              width: ScreenUtil().setWidth(208),
              alignment: Alignment.center,
              color: ColorConstant.blueBgColor,
              child: Text(
                '确定',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36), color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //订单金额组件
  Widget _orderPriceWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(80),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  '应付金额',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color: ColorConstant.greyTextColor),
                ),
              ),
              Container(
                child: Text(
                  '  (未支付)',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: ColorConstant.redTextColor),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              '¥${_totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: ColorConstant.redTextColor),
            ),
          ),
        ],
      ),
    );
  }

  //订单总金额组件
  Widget _totalPriceWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(76),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              '合计：(${_confirmGoodsList.length}件)',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: ColorConstant.greyTextColor),
            ),
          ),
          Container(
            child: Text(
              '¥${_totalPrice}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: ColorConstant.greyTextColor),
            ),
          ),
        ],
      ),
    );
  }

  //确认商品组件
  Widget _confirmGoodsListWidget(List<GoodsList> _confirmGoodsList) {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(20)),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(), //禁止滑动
          shrinkWrap: true,
          itemCount: _confirmGoodsList.length,
          itemBuilder: (BuildContext context, int position) {
            return SingleGoodsWidget(
              goods: _confirmGoodsList[position],
            );
          }),
    );
  }

  //订单基本详情组件
  Widget _orderInfoWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          _singleInfoWidget('images/person_grey_icon.png', userName, true),
          _singleInfoWidget('images/phone_grey_icon.png', receivePhone, true),
          _singleInfoWidget(
              'images/order_address_end.png', orderEndAddress, false),
        ],
      ),
    );
  }

  Widget _singleInfoWidget(
      String imageAssets, String content, bool showBorder) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      child: Container(
        height: AutoLayout.instance.pxToDp(78),
        decoration: BoxDecoration(
            border: showBorder
                ? Border(bottom: BorderSide(color: ColorConstant.greyLineColor))
                : null),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: AutoLayout.instance.pxToDp(40),
              child: Image.asset(
                imageAssets,
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
              child: Text(
                content,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(29),
                    color: ColorConstant.blackTextColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
