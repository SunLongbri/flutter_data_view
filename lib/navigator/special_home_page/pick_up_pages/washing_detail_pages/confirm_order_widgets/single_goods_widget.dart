import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_widgets/photo_preview_widget.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:provider/provider.dart';

//单个商品组件
class SingleGoodsWidget extends StatefulWidget {
  final GoodsList goods;

  const SingleGoodsWidget({Key key, this.goods}) : super(key: key);

  @override
  _SingleGoodsWidgetState createState() => _SingleGoodsWidgetState();
}

class _SingleGoodsWidgetState extends State<SingleGoodsWidget> {
  DataProvider _dataProvider;
  List<String> _partsGoodsList;
  bool _partSignForState; //订单是否处于标记状态

  @override
  void initState() {
    _partSignForState = true;
    _partsGoodsList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    _partsGoodsList = _dataProvider.getPartsGoodsList ?? [];
    _partSignForState = _dataProvider.getPartSignForState;

    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(212),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_goodsInfoWidget(context), _goodsMarkWidget()],
      ),
    );
  }

  //商品备注组件
  Widget _goodsMarkWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(8),
          bottom: AutoLayout.instance.pxToDp(8)),
      child: Text(
        '备注：${widget.goods.goodsFlawMark}',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(24),
            color: ColorConstant.greyTextColor),
      ),
    );
  }

  //商品基本信息组件
  Widget _goodsInfoWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(24),
          right: ScreenUtil().setWidth(22),
          top: AutoLayout.instance.pxToDp(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhotoPreviewWidget(
                              goodsUrl: widget.goods.goodsUrl,
                            )));
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(152),
                    height: AutoLayout.instance.pxToDp(136),
                    child: Image.network(
                      widget.goods.goodsUrl[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      color: Color(0x30000000),
                      height: AutoLayout.instance.pxToDp(40),
                      width: ScreenUtil().setWidth(152),
                      child: Text(
                        '${widget.goods.goodsUrl.length}张图片',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Colors.white),
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _partsGoodsList.contains(widget.goods.goodsNum)
                          ? '[童]${widget.goods.goodsName}'
                          : widget.goods.goodsName,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: ColorConstant.blackTextColor),
                    )),
                    widget.goods?.goodsFlawState ?? null == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(8),
                                right: ScreenUtil().setWidth(8),
                                top: AutoLayout.instance.pxToDp(1)),
                            decoration: BoxDecoration(
                              color: ColorConstant.blueBgLightColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(7),
                                  right: ScreenUtil().setWidth(7)),
                              child: Text(
                                widget.goods?.goodsFlawState ?? '',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(22),
                                    color: ColorConstant.blueTextColor),
                              ),
                            ),
                          )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '条码：${widget.goods.goodsNum}${widget.goods.goodsCurrentState == null ? '' : '（${widget.goods.goodsCurrentState ?? ''}）'}',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: ColorConstant.greyTextColor),
                    ),
                  ],
                )
              ],
            ),
          )),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Text(
                  '¥${widget.goods.goodsPrice}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: ColorConstant.blackTextColor),
                ),
              ),
              _partSignForState
                  ? InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          if (_partsGoodsList.contains(widget.goods.goodsNum)) {
                            _partsGoodsList.remove(widget.goods.goodsNum);
                          } else {
                            _partsGoodsList.add(widget.goods.goodsNum);
                          }
                          _dataProvider.setPartsGoodsList = _partsGoodsList;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: AutoLayout.instance.pxToDp(20)),
                        height: AutoLayout.instance.pxToDp(44),
                        width: ScreenUtil().setWidth(44),
                        child: _partsGoodsList.contains(widget.goods.goodsNum)
                            ? Image.asset('images/select_icon.png')
                            : Image.asset('images/unselect_icon.png'),
                      ),
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
