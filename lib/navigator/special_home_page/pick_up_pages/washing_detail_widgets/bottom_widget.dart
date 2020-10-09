import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/calendar_test_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/calendar_info_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/order_mark_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/select_clothes_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/drawing_board_page.dart';
import 'package:fluttermarketingplus/widgets/message_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

//底部按钮组件
class BottomWidget extends StatefulWidget {
  String orderId;
  String orderState;
  String goodsPayState;
  WashingDetail washingDetail;

  BottomWidget(
      {Key key,
      this.orderId,
      this.orderState,
      this.goodsPayState,
      this.washingDetail})
      : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  String orderState;
  String orderId;
  String goodsPayState;
  DataProvider _dataProvider;
  WashingDetail _washingDetail;
  String content = '';
  String _rightBtnContent = ''; //强行更改按钮文字

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    orderId = widget.orderId;
    goodsPayState = widget.goodsPayState;
    _dataProvider = Provider.of<DataProvider>(context);
    _washingDetail = widget.washingDetail;
    orderState = widget.orderState;

    if (orderState == '派送中') {
      if (goodsPayState == '未支付') {
        content = '已在其他平台支付';
      } else if (_dataProvider.getPartSignForState) {
        content = '签收(${_dataProvider.getPartsGoodsList.length})';
      } else {
        content = '签收';
      }
    } else if (orderState == '未受理') {
      content = '受理';
    } else {
      content = '取件';
    }
    if (_rightBtnContent.isNotEmpty) {
      if (_dataProvider.getPartSignForState) {
        content =
            '${_rightBtnContent}(${_dataProvider.getPartsGoodsList.length})';
      } else {
        content = _rightBtnContent;
      }
    }
    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(82),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buttonWidget('备注', context),
          orderState == '已签收'
              ? Container()
              : orderState != '未受理'
                  ? _buttonWidget('券码', context)
                  : Container(),
          orderState == '派送中' ? _buttonWidget('部分签收', context) : Container(),
          orderState == '已取件'
              ? Container()
              : orderState == '已签收' ? Container() : _rightBtn(context)
        ],
      ),
    );
  }

  Widget _rightBtn(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (content == '已在其他平台支付') {
          var formData = {"orderNumber": orderId, "payState": "已支付"};
          postRequest(API.EDITING_ORDER_PAY_STATE, formData,
                  tempBaseUrl: API.TEST_BASE_URL)
              .then((value) {
            ResponseModel responseModel = ResponseModel.fromJson(value);
            if (responseModel.code == 200) {
              setState(() {
                _rightBtnContent = '签收';
              });
              _dataProvider.setOrderPayState = '已支付';
            }
          });
        } else if (content == '取件') {
          //如果是取件按钮，则执行下方代码
          GlobalData.prefs.setString('user_name', _washingDetail.customerName);
          GlobalData.prefs
              .setString('receive_phone', _washingDetail.receivePhone);
          GlobalData.prefs
              .setString('order_end_address', _washingDetail.orderEndAddress);
          _dataProvider.setCurrentBindOrderId = orderId;
          _dataProvider.isRefresh = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectClothesPage(
                    cityName: '上海市',
                    orderId: orderId,
                  )));
        } else if (content.contains('签收')) {
          if (_dataProvider.getPartSignForState) {
            //部分签收
            List<String> partGoodsList = _dataProvider.getPartsGoodsList;
            if (partGoodsList.isEmpty) {
              showToast('请先选择要签收的衣物!');
              return;
            }
            //跳转到客户签名页面
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DrawingBoardPage(
                      orderId: orderId,
                      partGoodsList: partGoodsList,
                    )));
          } else {
            //全部订单签收
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DrawingBoardPage(
                      orderId: orderId,
                      allCount: _washingDetail.goodsList.length,
                    )));
          }
        } else if (content == '受理') {
          PickUpTask _pickUpTask = PickUpTask();
          _pickUpTask.receiveName = _washingDetail.receiveName;
          _pickUpTask.sendName = _washingDetail.customerName;
          _pickUpTask.sendPhone = _washingDetail.sendPhone;
          _pickUpTask.receivePhone = _washingDetail.receivePhone;
          _pickUpTask.orderId = _washingDetail.orderNumber;
          _dataProvider.isRefresh = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CalendarTestPage(
                    pickUpTask: _pickUpTask,
                  )));
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(202),
        color: ColorConstant.blueBgColor,
        child: Text(
          content,
          style: TextStyle(
            color: Colors.white,
            fontSize: content.length > 5
                ? ScreenUtil().setSp(30)
                : ScreenUtil().setSp(36),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buttonWidget(String rightBtnContent, BuildContext context) {
    double btnWith = 0;
    if (rightBtnContent.length == 2) {
      btnWith = 120;
    } else if (rightBtnContent.length == 4) {
      btnWith = 174;
    }
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      height: AutoLayout.instance.pxToDp(52),
      width: ScreenUtil().setWidth(btnWith),
      child: FlatButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColorConstant.blueTextColor, width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () {
            if (rightBtnContent == '备注') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderMarkPage(
                        orderId: orderId,
                      )));
            } else if (rightBtnContent == '券码') {
              MessageDialogWidget(
                  titles: '券码',
                  message: '',
                  textFieldHintContent: '请输入券码',
                  onConfirmEvent: () {
                    Navigator.pop(context);
                  },
                  block: (val) {
                    var formData = {"orderId": orderId, "codeNum": val.trim()};
                    postRequest(API.CODE_MARK, formData,
                            tempBaseUrl: API.TEST_BASE_URL)
                        .then((value) {
                          print('添加券码参数:${formData.toString()}');
                      ResponseModel responseModel =
                          ResponseModel.fromJson(value);
                      if (responseModel.code == 200) {
                        showToast('成功！');
                        _dataProvider.setOrderCode = val.trim();
                        _dataProvider.isRefresh = true;
                        setState(() {});
                        Navigator.pop(context);
                      } else {
                        showToast(responseModel.message);
                      }
                    });
                  },
                  onCloseEvent: () {
                    Navigator.pop(context);
                  }).show(context);
            } else if (rightBtnContent == '部分签收') {
              if (content.contains('签收')) {
                _dataProvider.setPartSignForState = true;
              } else {
                showToast('请先支付订单');
              }
            }
          },
          child: Text(
            rightBtnContent,
            style: TextStyle(
                color: ColorConstant.blueTextColor,
                fontSize: ScreenUtil().setSp(25)),
          )),
    );
  }
}
