import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/goods_list_model.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/select_clothes_pages/edit_goods_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

//右侧商品列表组件
class RightGoodsWidget extends StatefulWidget {
  final String orderId;

  const RightGoodsWidget({Key key, this.orderId}) : super(key: key);

  @override
  _RightGoodsWidgetState createState() => _RightGoodsWidgetState();
}

class _RightGoodsWidgetState extends State<RightGoodsWidget> {
  DataProvider _dataProvider;
  List<SingleGoods> goodsList;

  //初始化商品列表信息
  @override
  void initState() {
    goodsList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    goodsList = _dataProvider.getGoodsList;
    return Container(
      child: ListView.builder(
          itemCount: goodsList.length,
          itemBuilder: (BuildContext context, int position) {
            return _singleGoodsWidget(goodsList, position);
          }),
    );
  }

  Widget _singleGoodsWidget(List<SingleGoods> goodsList, int position) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        //跳转到扫码页面，然后再跳转到编辑商品信息
        JumpReceive()
            .jump(context, Routes.deliveryOrderScanQrPage)
            .then((value) {
          print('value:${value}');
          String goodsCode = value;
          if (!goodsCode.startsWith('A') && !goodsCode.endsWith('A')) {
            goodsCode = 'A${value}A';
          }
          //判断该衣物码是否已经被其他衣物绑定过
          var formData = {"code": goodsCode};
          postRequest(API.MATCH_CLOTHES_CODE, formData,tempBaseUrl: API.TEST_BASE_URL).then((value) {
            ResponseModel responseModel = ResponseModel.fromJson(value);
            if (responseModel.code == 200) {
              if (responseModel.data == '已绑码') {
                showToast('该码已经绑过其他衣物，请更换码！');
                return;
              }
              //更改衣物数据
              showToast(responseModel.data);
              _exchangeClothesData(goodsCode, position);
            } else {
              showToast(responseModel.message);
            }
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(44),
            top: AutoLayout.instance.pxToDp(48)),
        child: Row(
          children: <Widget>[
            Container(
              height: AutoLayout.instance.pxToDp(108),
              child: Image.network(
                goodsList[position].imageUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(34)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(250),
                          child: Text(
                            goodsList[position].goodsName,
                            style: TextStyle(
                                color: ColorConstant.blackTextColor,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                        ),
                        goodsList[position].count != null
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(16)),
                                decoration: BoxDecoration(
                                    color: ColorConstant.redBgColor,
                                    borderRadius: BorderRadius.circular(100)),
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(7),
                                    right: ScreenUtil().setWidth(7)),
                                child: Text(
                                  '${goodsList[position].count}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(28)),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: AutoLayout.instance.pxToDp(18)),
                    child: Text(
                      '¥${goodsList[position].goodsPrice}',
                      style: TextStyle(
                          color: ColorConstant.redTextColor,
                          fontSize: ScreenUtil().setSp(30)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _exchangeClothesData(String goodsCode, int position) {
    print('goodsCode:${goodsCode}');
    _dataProvider.setThirdChildKey = goodsList[position].goodsId;

    //将商品的网络图片存储到本地
    GlobalData.prefs.setString('goods_url', goodsList[position].imageUrl);
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => EditGoodsPage(
                  orderId: widget.orderId,
                  goodsCode: goodsCode,
                  goodsName: goodsList[position].goodsName,
                  goodsPrice: goodsList[position].goodsPrice,
                )))
        .then((value) {
      if (value != null) {
        print('=========>绑码返回数据:${value}');

        //商品列表单个商品加一，并更改缓存中的数据
        if (goodsList[position].count == null) {
          goodsList[position].count = 0;
        }
        goodsList[position].count++;

        //更改价格
        double totalPrice = _dataProvider.getTotalPrice;
        totalPrice = totalPrice +
            goodsList[position].count *
                double.parse(goodsList[position].goodsPrice);

        //修改缓存中 商品总数量 的数据
        Map<String, int> countMap = _dataProvider.getTempCountMap;
        int count = 0;
        for (int i = 0; i < goodsList.length; i++) {
          if (goodsList[i].count == null) {
            continue;
          }
          count += goodsList[i].count;
        }
        _dataProvider.setGoodsList = goodsList;
        _dataProvider.setTotalPrice = totalPrice;
        countMap[_dataProvider.getSecondChildKey] = count;
        _dataProvider.setRefreshTab = true;
      } else {
        showToast('当前未绑码!');
      }
    });
  }
}
