import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/edit_address_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/message_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCardWidget extends StatefulWidget {
  final String washingId;
  final WashingDetail washingDetail;

  const OrderCardWidget({Key key, this.washingId, this.washingDetail})
      : super(key: key);

  @override
  _OrderCardWidgetState createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  WashingDetail _washingDetail;
  String _codeNumber;
  DataProvider _dataProvider;

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    _washingDetail = widget.washingDetail;
    _codeNumber = _washingDetail?.codeNum ?? '';
    return Column(
      children: <Widget>[
        _washingTitleWidget(widget.washingId),
        _orderContentWidget(),
      ],
    );
  }

  Widget _washingTitleWidget(String orderId) {
    List<String> _weightStr = _washingDetail?.orderWeight ?? [];
    Color textColor = ColorConstant.blackTextColor;
    List<Widget> _weightWidgets = [];
    if (_weightStr.contains('首单')) {
      _weightWidgets.add(_singleWeightWidget('images/order_weight_first.png'));
    }
    if (_weightStr.contains('包月')) {
      _weightWidgets.add(_singleWeightWidget('images/order_weight_month.png'));
    }
    if (_weightStr.contains('超时')) {
      _weightWidgets
          .add(_singleWeightWidget('images/order_weight_overtime.png'));
    }
    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(82),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(10)),
            width: ScreenUtil().setWidth(40),
            child: Image.asset(
              'images/order_icon.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            child: Text(
              '订单编号:${orderId}',
              style:
                  TextStyle(color: textColor, fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _weightWidgets,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(26)),
                child: Text(
                  _washingDetail?.orderState ?? '',
                  style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: ScreenUtil().setSp(28)),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _singleWeightWidget(String imgAssets) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
      width: ScreenUtil().setWidth(42),
      child: Image.asset(
        imgAssets,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _orderContentWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: AutoLayout.instance.pxToDp(20)),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _orderTitleWidget(),
          _orderInfoWidget(),
          _orderMarkWidget(_washingDetail?.customerMark ?? '',
              _washingDetail?.deliverMark ?? ''),
          _orderTimeWidget(),
          _codeNumber.isEmpty ? Container() : _codeNumberWidget()
        ],
      ),
    );
  }

  //券码显示
  Widget _codeNumberWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(80),
      child: Row(
        children: <Widget>[
          Text(
            '券码：',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                color: ColorConstant.blackTextColor),
          ),
          Text(
            _codeNumber,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                color: ColorConstant.greyTextColor),
          )
        ],
      ),
    );
  }

  Widget _orderTimeWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(28),
          right: ScreenUtil().setWidth(28),
          top: AutoLayout.instance.pxToDp(20),
          bottom: AutoLayout.instance.pxToDp(20)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '下单时间：${_washingDetail?.placeOrderTime ?? ''}',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(28)),
          ),
          Text(
            '预约时间：${_washingDetail?.subscribeTime ?? ''}',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(28)),
          ),
          _washingDetail?.arriveTime != null
              ? Text(
                  '预计上门：${_washingDetail?.arriveTime ?? ''}',
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(28)),
                )
              : Container(),
          _washingDetail?.expectArriveTime != null
              ? Text(
                  '期望送达时间：${_washingDetail?.expectArriveTime ?? ''}',
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(28)),
                )
              : Container(),
          _washingDetail?.getGoodsTime != null
              ? Text(
                  '取件时间：${_washingDetail?.getGoodsTime ?? ''}',
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(28)),
                )
              : Container(),
          _washingDetail?.signForTime != null
              ? Text(
                  '签收时间：${_washingDetail?.signForTime ?? ''}',
                  style: TextStyle(
                      color: ColorConstant.greyTextColor,
                      fontSize: ScreenUtil().setSp(28)),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _orderMarkWidget(String customerMark, String deliverMark) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30),
          top: AutoLayout.instance.pxToDp(20),
          bottom: AutoLayout.instance.pxToDp(20)),
      color: ColorConstant.greyBgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '客户备注：${customerMark}',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(28)),
          ),
          Text(
            '小哥备注：${deliverMark}',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(28)),
          )
        ],
      ),
    );
  }

  Widget _orderInfoWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          _singleRowWidget(
            'images/person_grey_icon.png',
            _washingDetail?.customerName ?? '',
          ),
          _singleRowWidget(
              'images/phone_icon.png', _washingDetail?.receivePhone ?? '',
              endIconImg: 'images/phone_blue_icon.png', onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (dialogContext, scrollController) {
                return StatefulBuilder(
                  builder: (context, mSetState) {
                    return Container(
                      color: Colors.white,
                      height: AutoLayout.instance.pxToDp(376),
                      width: ScreenUtil().setWidth(750),
                      child: Column(
                        children: <Widget>[
                          _bottomTitleWidget(),
                          _bottomGreyLineWidget(),
                          _bottomContentWidget(mSetState)
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }),
          _singleRowWidget(
              'images/order_address_start.png',
              _editStartAddress.isEmpty
                  ? _washingDetail?.orderStartAddress ?? ''
                  : _editStartAddress,
              endIconImg: 'images/edit_blue_icon.png', onTap: () {
            _editStartAddress = _washingDetail?.orderStartAddress ?? '';
            MessageDialogWidget(
                textFieldContent: _editStartAddress.isEmpty
                    ? _washingDetail?.orderStartAddress ?? ''
                    : _editStartAddress,
                message: '',
                titles: '修改收件地址',
                onCloseEvent: () {
                  Navigator.pop(context);
                },
                block: (val) {
                  print('修改之后的地址为:${val}');
                  var formData = {
                    "orderId": widget.washingId,
                    "addressType": "1",
                    "address": val
                  };
                  postRequest(API.EDIT_ADDRESS, formData,
                          tempBaseUrl: API.TEST_BASE_URL)
                      .then((value) {
                    ResponseModel responseModel = ResponseModel.fromJson(value);
                    if (responseModel.code == 200) {
                      if (responseModel.message.contains('成功')) {
                        setState(() {
                          _editStartAddress = val;
                        });
                        Navigator.pop(context);
                      }
                    } else {
                      showToast(responseModel.message);
                    }
                  });
                },
                onConfirmEvent: () {
                  Navigator.pop(context);
                }).show(context);
          }),
          _singleRowWidget(
              'images/order_address_end.png',
              _editEndAddress.isEmpty
                  ? _washingDetail?.orderEndAddress ?? ''
                  : _editEndAddress,
              endIconImg: 'images/edit_blue_icon.png', onTap: () {
            _editEndAddress = _washingDetail?.orderEndAddress ?? '';
            MessageDialogWidget(
                textFieldContent: _editEndAddress.isEmpty
                    ? _washingDetail?.orderEndAddress ?? ''
                    : _editEndAddress,
                message: '',
                titles: '修改送件地址',
                onCloseEvent: () {
                  Navigator.pop(context);
                },
                block: (val) {
                  print('修改之后的地址为:${val}');
                  var formData = {
                    "orderId": widget.washingId,
                    "addressType": "2",
                    "address": val
                  };
                  postRequest(API.EDIT_ADDRESS, formData,
                          tempBaseUrl: API.TEST_BASE_URL)
                      .then((value) {
                    ResponseModel responseModel = ResponseModel.fromJson(value);
                    if (responseModel.code == 200) {
                      if (responseModel.message.contains('成功')) {
                        setState(() {
                          _editEndAddress = val;
                        });
                        showToast(responseModel.message);
                        Navigator.pop(context);
                      }
                    } else {
                      showToast(responseModel.message);
                    }
                  });
                },
                onConfirmEvent: () {
                  Navigator.pop(context);
                }).show(context);
          }),
        ],
      ),
    );
  }

  String _editStartAddress = ''; //修改地址
  String _editEndAddress = ''; //修改地址

  List<Widget> _phoneWidgets = [];

  Widget _bottomContentWidget(Function mSetState) {
    _phoneWidgets.clear();
    _phoneWidgets.add(_singleBottomBtn(
        '联系收件人', _washingDetail?.receivePhone ?? '', mSetState));
    _phoneWidgets.add(
        _singleBottomBtn('联系下单人', _washingDetail?.sendPhone ?? '', mSetState));
    return Container(
      child: Column(
        children: _phoneWidgets,
      ),
    );
  }

  String _phoneKey = '联系收件人';

  Widget _singleBottomBtn(String content, String tel, Function mSetState) {
    bool _isClick = false;
    if (content == _phoneKey) {
      _isClick = true;
    }
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        mSetState(() {
          _phoneKey = content;
        });
        _launcherURL(tel);
        Navigator.pop(context);
      },
      child: Container(
        width: ScreenUtil().setWidth(274),
        height: AutoLayout.instance.pxToDp(72),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(44)),
        decoration: BoxDecoration(
            border: Border.all(
                color: _isClick
                    ? ColorConstant.blueTextColor
                    : ColorConstant.greyTextColor,
                width: 1),
            borderRadius: BorderRadius.all(Radius.circular(9))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              content,
              style: TextStyle(
                  color: _isClick
                      ? ColorConstant.blueTextColor
                      : ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
              width: ScreenUtil().setWidth(40),
              child: Image.asset(
                _isClick
                    ? 'images/phone_blue_icon.png'
                    : 'images/phone_grey_icon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomGreyLineWidget() {
    return Container(
        width: ScreenUtil().setWidth(750),
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(3),
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(44),
          right: ScreenUtil().setWidth(44),
        ),
        color: ColorConstant.greyBgColor);
  }

  Widget _bottomTitleWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(24),
          right: ScreenUtil().setWidth(24),
          top: AutoLayout.instance.pxToDp(24),
          bottom: AutoLayout.instance.pxToDp(36)),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(46),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '选择联系人',
                style: TextStyle(
                    color: ColorConstant.blackTextColor,
                    fontSize: ScreenUtil().setSp(36)),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: ScreenUtil().setWidth(46),
              child: Image.asset('images/close_fill_icon.png'),
            ),
          ),
        ],
      ),
    );
  }

  void _launcherURL(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问,异常!';
    }
  }

  Widget _singleRowWidget(String startIconImg, String content,
      {String endIconImg, VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(18),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          bottom: AutoLayout.instance.pxToDp(10)),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
            width: ScreenUtil().setWidth(40),
            height: AutoLayout.instance.pxToDp(40),
            child: Image.asset(
              startIconImg,
              fit: BoxFit.fitHeight,
            ),
          ),
          Expanded(
              child: Container(
            child: Text(
              content,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          )),
          endIconImg == null
              ? Container()
              : InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: onTap,
                  child: Container(
                    width: ScreenUtil().setWidth(40),
                    height: AutoLayout.instance.pxToDp(40),
                    child: Image.asset(endIconImg),
                  ),
                )
        ],
      ),
    );
  }

  Widget _orderTitleWidget() {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(26), right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffEFEFEF)))),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(12)),
            height: AutoLayout.instance.pxToDp(80),
            width: ScreenUtil().setWidth(36),
            child: Image.asset('images/order_source_icon.png'),
          ),
          Container(
              child: Text(
            _washingDetail?.orderSource ?? '',
            style: TextStyle(
                color: Color(0xff999999), fontSize: ScreenUtil().setSp(26)),
          )),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              '（${_washingDetail?.workerNumber ?? ''}）${_washingDetail?.workerName ?? ''}',
              style: TextStyle(
                  color: Color(0xff999999), fontSize: ScreenUtil().setSp(26)),
            ),
          ))
        ],
      ),
    );
  }
}
