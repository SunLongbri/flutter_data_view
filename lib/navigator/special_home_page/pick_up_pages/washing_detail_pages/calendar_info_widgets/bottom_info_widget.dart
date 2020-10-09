import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/model/response_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//日历页面，底部信息组件
class BottomInfoWidget extends StatefulWidget {
  final PickUpTask pickUpTask;

  const BottomInfoWidget({Key key, this.pickUpTask}) : super(key: key);

  @override
  _BottomInfoWidgetState createState() => _BottomInfoWidgetState();
}

class _BottomInfoWidgetState extends State<BottomInfoWidget> {
  PickUpTask _pickUpTask;

  @override
  void initState() {
    _pickUpTask = widget.pickUpTask;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider _dataProvider = Provider.of<DataProvider>(context);
    return Container(
      color: Colors.white,
      height: AutoLayout.instance.pxToDp(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(29)),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(40),
                      child: Image.asset(
                        'images/person_grey_icon.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                      child: Text(
                        (_pickUpTask?.receiveName ?? '').isEmpty
                            ? (_pickUpTask?.sendName ?? '')
                            : _pickUpTask?.receiveName,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(29),
                            color: ColorConstant.blackTextColor),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
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
                },
                child: Container(
                  height: AutoLayout.instance.pxToDp(52),
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(113),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(color: ColorConstant.blueTextColor)),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(78)),
                  child: Text(
                    '拨号',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: ColorConstant.blueTextColor),
                  ),
                ),
              ),
            ],
          )),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              String selectTime = _dataProvider.getSelectTime;
              if (_dataProvider.getUserSelectPosition == 0) {
                showToast('请先选择预约时间!');
                return;
              }
              if (selectTime.isEmpty) {
                showToast('请先选择预约时间!');
                return;
              }
              List<String> time = selectTime.split('-');
              int year = int.parse(time[0]);
              int month = int.parse(time[1]);
              List<String> subTime = time[2].split(' ');
              int day = int.parse(subTime[0]);
              int hour = _dataProvider.getUserSelectPosition;
              DateTime selectDateTime = DateTime(year, month, day, hour);
              DateTime currentDateTime = DateTime.now();

              var diff = selectDateTime.difference(currentDateTime);
              if (diff.inHours < 0) {
                showToast('选择时间小于当前时间!');
                return;
              }
              var formData = {
                "orderNumber": _pickUpTask.orderId,
                "receiveTime": selectTime,
                "receivePhone": _pickUpTask.receivePhone,
                "receiveName": _pickUpTask.receiveName,
                "sendName": _pickUpTask.sendName,
                "sendPhone": _pickUpTask.sendPhone
              };
              postRequest(API.ACCEPT_ORDER, formData,
                      tempBaseUrl: API.TEST_BASE_URL)
                  .then((value) {
                print('预约上传参数为:${formData}');
                ResponseModel responseModel = ResponseModel.fromJson(value);
                if (responseModel.code == 200) {
                  _dataProvider.setSelectTime = '';
                  showToast('预约成功!');
                  _dataProvider.isRefresh = true;
                  Navigator.pop(context);
                } else {
                  showToast(responseModel.message);
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              color: ColorConstant.blueBgColor,
              width: ScreenUtil().setWidth(200),
              child: Text(
                '预约',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36), color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
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

  List<Widget> _phoneWidgets = [];
  String _phoneKey = '联系收件人';

  Widget _bottomContentWidget(Function mSetState) {
    _phoneWidgets.clear();
    _phoneWidgets.add(
        _singleBottomBtn('联系收件人', _pickUpTask?.receivePhone ?? '', mSetState));
    _phoneWidgets.add(
        _singleBottomBtn('联系下单人', _pickUpTask?.sendPhone ?? '', mSetState));
    return Container(
      child: Column(
        children: _phoneWidgets,
      ),
    );
  }

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
}
