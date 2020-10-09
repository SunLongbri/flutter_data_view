import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/routers/router_handler.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/view/delivery_order_listview.dart';

class DeliveryOrderCreate extends StatefulWidget {
  @override
  _DeliveryOrderCreateState createState() => _DeliveryOrderCreateState();
}

class _DeliveryOrderCreateState extends State<DeliveryOrderCreate> {
  TextEditingController _searchBarcodeController = TextEditingController();
  String _deliveryProcess; // 1：干线到工厂；2：干线到门店；
  String _searchBarcodeNum = '';//手动输入条码号
  int _selectGoodsNum = 0;//已经选择的商品数量
  int _allGoodsNum = 0;//所有商品数
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deliveryProcess = '干线到工厂';
    _allGoodsNum = 10;
    _selectGoodsNum = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '创建交接单',
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              //键盘回收
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  _titleWidget('交接信息', false),
                  _rowLine('交接日期',
                      formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])),
                  _rowLine('交接人', GlobalData.prefs.getString('user_name')),
                  _popSelectWidget('交接流程', _deliveryProcess, () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    BottomCupertionWidget(listContent: [
                      '干线到工厂',
                      '干线到门店',
                    ]).selectData(context).then((val) {
                      if (val == null) {
                        return;
                      }
                      setState(() {
                        _deliveryProcess = val;
                      });
                    });
                  }),
                  _deliveryProcess == '干线到工厂'
                      ? Container()
                      : _rowLine(
                          '交接门店', GlobalData.prefs.getString('user_name')),
                  _rowLine('接收人', GlobalData.prefs.getString('user_name')),
                  SizedBox(
                    height: 10,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                  _titleWidget('交接商品', true),
                  _deliveryProcess == '干线到工厂'
                      ? Container()
                      : _searchBarcodeWidget(),
                  DeliveryOrderListView(deliveryProcess: _deliveryProcess,from: 'create') 
                ],
              )),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffABABAB), width: 1),
            color: Colors.black12,
          ),
          height: 40.0,
          child: _bottomNavigationContainer()
        ));
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
            width: AutoLayout.instance.pxToDp(120),
            child: Text(
              text,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(220),
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

//底部弹出框
  Widget _popSelectWidget(String title, String content, VoidCallback callback) {
    return Container(
      height: AutoLayout.instance.pxToDp(98),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(28), right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            width: AutoLayout.instance.pxToDp(120),
            child: Text(
              title,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          InkWell(
            onTap: callback,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              child: Row(
                children: [
                  Text(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorConstant.hintTextColor,
                        fontSize: ScreenUtil().setSp(26)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(14),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Image.asset(
                      'images/arrow_down.png',
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //搜索商品
  Widget _searchBarcodeWidget() {
    return Container(
      height: 50,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
            height: 40,
            child: TextField(
              controller: _searchBarcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                hintText: '查询交接单内是否有此商品',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.score),
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(8), //边角为8
                  ),
                  borderSide: BorderSide(
                    color: Colors.grey, 
                    width: 1, //边线宽度为1
                  ),
                ),
              ),
              onChanged: (String str) {
                _searchBarcodeNum = str;
                print('onChangedr:$_searchBarcodeNum');
              },
            ),
          )),

          //查询按钮
          Container(
            margin: EdgeInsets.all(8),
            child: OutlineButton(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                highlightedBorderColor: Theme.of(context).primaryColor,
                disabledBorderColor: Theme.of(context).primaryColor,
                highlightColor: Colors.pink[100],
                onPressed: () {
                  print('查询$_searchBarcodeNum');
                },
                child: Container(
                  child: Text('查询'),
                )),
          )
        ],
      ),
    );
  }

  Widget _bottomNavigationContainer(){
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(child: Text('已选$_selectGoodsNum条/总$_allGoodsNum条')),
          Container(
            margin: EdgeInsets.all(8),
            child: OutlineButton(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                highlightedBorderColor: Theme.of(context).primaryColor,
                disabledBorderColor: Theme.of(context).primaryColor,
                highlightColor: Colors.pink[100],
                onPressed: () {
                  print('查询$_searchBarcodeNum');
                },
                child: Container(
                  child: Text('创建交接单'),
                )),
          )
        ],
      ),
    );
  }
}
