import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:provider/provider.dart';

import 'single_goods_widget.dart';

//商品列表数据组件
class GoodsListWidget extends StatefulWidget {
  final List<GoodsList> goodsList; //商品数据列表
  final double goodsTotalPrice; //商品总金额
  final String goodsPayState; //订单支付状态
  final WashingDetail washingDetail;

  const GoodsListWidget(
      {Key key,
      this.goodsList,
      this.goodsTotalPrice,
      this.goodsPayState,
      this.washingDetail})
      : super(key: key);

  @override
  _GoodsListWidgetState createState() => _GoodsListWidgetState();
}

class _GoodsListWidgetState extends State<GoodsListWidget> {
  List<GoodsList> _goodsList;
  double _goodsTotalPrice; //商品总金额
  String _goodsPayState; //订单支付状态
  bool _loadMore; //是否加载更多
  DataProvider _dataProvider;

  @override
  void initState() {
    _loadMore = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _goodsList = widget.goodsList;
    _goodsTotalPrice = widget.goodsTotalPrice;
    _goodsPayState = widget.goodsPayState;
    if (_goodsList.length <= 15) {
      //小于15个商品，不用加载更多
      _loadMore = true;
    }
    _dataProvider = Provider.of<DataProvider>(context);
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorConstant.greyLineColor))),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(), //禁止滑动
                  shrinkWrap: true,
                  itemCount: _goodsList.length > 15
                      ? _loadMore ? _goodsList.length : 15
                      : _goodsList.length,
                  itemBuilder: (BuildContext context, int position) {
                    return SingleGoodsWidget(goods: _goodsList[position]);
                  }),
            ),
            _loadMore
                ? Container()
                : InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        _loadMore = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          top: AutoLayout.instance.pxToDp(10),
                          bottom: AutoLayout.instance.pxToDp(10)),
                      color: Colors.white,
                      child: Text(
                        '点击查看更多',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: ColorConstant.blueTextColor),
                      ),
                    ),
                  ),
            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20)),
              color: Colors.white,
              height: AutoLayout.instance.pxToDp(78),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '合计（${_goodsList.length}件）',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: ColorConstant.greyTextColor),
                  ),
                  Text(
                    '¥${_goodsTotalPrice}',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: ColorConstant.greyTextColor),
                  ),
                ],
              ),
            ),
            _dataProvider.getOrderCode.isEmpty
                ? Container()
                : (widget.washingDetail?.codeNum ?? '').isEmpty
                    ? Container()
                    : Container(
                        color: Colors.white,
                        height: AutoLayout.instance.pxToDp(80),
                        margin: EdgeInsets.only(
                          top: AutoLayout.instance.pxToDp(16),
                        ),
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '券码',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32),
                                      color: ColorConstant.blackTextColor),
                                ),
                                Text(
                                  ' :  ${_dataProvider.getOrderCode.isEmpty ? (widget.washingDetail?.codeNum ?? '') : _dataProvider.getOrderCode}',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32),
                                      color: ColorConstant.greyTextColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
            Container(
              color: Colors.white,
              height: AutoLayout.instance.pxToDp(80),
              margin: EdgeInsets.only(
                top: AutoLayout.instance.pxToDp(16),
              ),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '应付金额',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: ColorConstant.blackTextColor),
                      ),
                      Text(
                        '（${_dataProvider.getOrderPayState.isEmpty ? _goodsPayState : _dataProvider.getOrderPayState}）',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: ColorConstant.redTextColor),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '¥',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(23),
                            color: ColorConstant.redTextColor),
                      ),
                      Text(
                        _goodsTotalPrice.toString(),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: ColorConstant.redTextColor),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
