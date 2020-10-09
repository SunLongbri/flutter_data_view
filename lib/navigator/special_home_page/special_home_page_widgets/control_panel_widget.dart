import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/pickup_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/home_amap_page/order_list_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/special_home_page_widgets/control_panel_pages/all_order_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/next_latlng.dart';
import 'package:fluttermarketingplus/widgets/rotate_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../pick_up_page.dart';
import '../special_test_panel.dart';

//首页地图 下方控制面板组件
class ControlPanelWidget extends StatefulWidget {
  @override
  _ControlPanelWidgetState createState() => _ControlPanelWidgetState();
}

class _ControlPanelWidgetState extends State<ControlPanelWidget>
    with NextLatLng {
  bool _isRotate = false;
  DataProvider _dataProvider;
  List<LatLng> _pointList = [];
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //刷新按钮
          _refreshDataWidget(),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                _singleBtnWidget('取件', _pickUpFunction),
                _singleBtnWidget('送件', _deliveryFunction),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                top: AutoLayout.instance.pxToDp(18),
                bottom: AutoLayout.instance.pxToDp(14)),
            height: AutoLayout.instance.pxToDp(306),
            child: Column(
              children: <Widget>[
                //今日任务信息组件
                _infoWidget(),
                //任务一览组件
                _taskInfoWidget(),
                //灰线组件
                _greyLineWidget(),
                //文字功能组件
                _functionInfoWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //刷新按钮
  Widget _refreshDataWidget() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
      child: InkWell(
          onTap: () {
            if (_isRotate) {
              showToast('您刷新的太及时了 ... ');
              return;
            }
            setState(() {
              _isRotate = true;
            });
            Future.delayed(Duration(milliseconds: 2000)).then((value) async {
              setState(() {
                _isRotate = false;
              });
            });
            //请求数据
            Future.delayed(Duration(milliseconds: 1000)).then((value) async {
              _refreshMarkers(_dataProvider.getAmapController);
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: RotateView(
            icon: 'images/home_refresh.png', //旋转图片本地路径
            onShow: _isRotate, //是否旋转 true开始 false结束 为false时终止旋转动画和视图
            speed: 100, //速度
          )),
    );
  }

  _refreshMarkers(AmapController controller) async {
    await _dataProvider.getAmapController.clearMarkers(_dataProvider.getAmapMarkers);

    getRequest(API.SPECIAL_WASHING_PICKUP, tempBaseUrl: API.TEST_BASE_URL)
        .then((val) {
      SpecialWashingModel specialWashingModel =
          SpecialWashingModel.fromJson(val);
      _dataProvider.setSpecialWashingModel = specialWashingModel;
      if (specialWashingModel != null) {
        List<PickUpTaskList> pickUpTaskList =
            specialWashingModel.data.pickUpTaskList;
        List<DeliverTaskList> deliverTaskList =
            specialWashingModel.data.deliverTaskList;
        List<PickUpTaskList> acceptTaskList =
            specialWashingModel.data.acceptTaskList;

        _addMarkerList(pickUpTaskList, controller, '取').then((val) {
          _addMarkerList(deliverTaskList, controller, '送').then((val) {
            _addMarkerList(acceptTaskList, controller, '受').then((val) {
              _dataProvider.setAmapMarkers = _markers;
              controller?.zoomToSpan(
                _pointList,
                padding:
                    EdgeInsets.only(bottom: 270, left: 50, right: 50, top: 80),
              );

              Future.delayed(Duration(milliseconds: 2000)).then((e) {
                controller?.setMarkerClickedListener((marker) async {
                  String title = await marker.title;
                  title = title.substring(1, title.length);
                  showToast('title:${title}');
                  if (title.contains(',')) {
                    //该订单有多个订单
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderListPage(
                          orderStr: title,
                        )));
                  } else {
                    //该订单只有一个订单
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WashingDetailPage(
                          washingId: title,
                        )));
                  }
                  return true;
                });
              });
            });
          });
        });
      }
    });
  }

  //文字功能组件
  Widget _functionInfoWidget() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleFunctionWidget('全部订单',(){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AllOrderPage()));
          }),
          _columnLineWidget(),
          _singleFunctionWidget('查看提成',(){}),
          _columnLineWidget(),
          _singleFunctionWidget('功能大全',(){}),
        ],
      ),
    );
  }

  Widget _columnLineWidget() {
    return Container(
      alignment: Alignment.center,
      color: ColorConstant.greyLineColor,
      width: ScreenUtil().setWidth(2),
      height: AutoLayout.instance.pxToDp(20),
    );
  }

  Widget _singleFunctionWidget(String funcText,VoidCallback onTap) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          funcText,
          style: TextStyle(
              color: ColorConstant.blueTextColor,
              fontSize: ScreenUtil().setSp(30)),
        ),
      ),
    );
  }

  //灰线组件
  Widget _greyLineWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(32), right: ScreenUtil().setWidth(32)),
      height: AutoLayout.instance.pxToDp(2),
      color: ColorConstant.greyLineColor,
    );
  }

  //任务一览组件
  Widget _taskInfoWidget() {
    TaskInfo taskInfo =
        _dataProvider?.getSpecialWashingModel?.data?.taskInfo ?? TaskInfo();
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(38),
          bottom: AutoLayout.instance.pxToDp(32)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleTaskWidget(
              'images/special_get.png', '${taskInfo?.residueGet.toString()}个未取订单' ?? ''),
          _singleTaskWidget('images/special_push.png',
              '${taskInfo?.residuePush.toString()}个未送订单' ?? ''),
//          _singleTaskWidget(
//              'images/special_out.png', taskInfo?.residueOut.toString() ?? ''),
//          _singleTaskWidget(
//              'images/special_in.png', taskInfo?.residueIn.toString() ?? ''),
        ],
      ),
    );
  }

  Widget _singleTaskWidget(String imgAssets, String count) {
    Color textColor = Colors.black;
    if (imgAssets.contains('get')) {
      textColor = Color(0xff0DBAAA);
    } else if (imgAssets.contains('push')) {
      textColor = Color(0xffEEA422);
    } else if (imgAssets.contains('out')) {
      textColor = Color(0xff4DCBFD);
    } else if (imgAssets.contains('in')) {
      textColor = Color(0xffFF6D6D);
    }
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(84),
            child: Image.asset(imgAssets),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Text(
              count,
              style:
                  TextStyle(color: textColor, fontSize: ScreenUtil().setSp(25)),
            ),
          )
        ],
      ),
    );
  }

  //今日任务信息组件
  Widget _infoWidget() {
    TaskInfo taskInfo =
        _dataProvider?.getSpecialWashingModel?.data?.taskInfo ?? TaskInfo();
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(28)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _singleInfoRowWidget('今日提成:', '¥${taskInfo.todayCommission}' ?? ''),
          Container(
            child: Text(
              '今日任务',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(32),
                  fontFamily: 'PingFang',
                  fontWeight: FontWeight.w600),
            ),
          ),
          _singleInfoRowWidget('今日跑单:', '${taskInfo?.completed}单' ?? ''),
        ],
      ),
    );
  }

  //今日信息组件单个横向数据展示
  Widget _singleInfoRowWidget(String content, String msg) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              content,
              style: TextStyle(
                  color: ColorConstant.hintTextColor,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Text(
              msg,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(28)),
            ),
          ),
        ],
      ),
    );
  }

  //取件函数
  _pickUpFunction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PickUpPage(
        tabType: '取',
      )),
    );
  }

  //送件函数
  _deliveryFunction() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PickUpPage(
              tabType: '送',
            )));
  }

  //单个控制按钮组件
  Widget _singleBtnWidget(String content, Function onTap) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      child: FlatButton(
          color: Color(0xff4EB8FB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: onTap,
          child: Container(
            alignment: Alignment.center,
            height: AutoLayout.instance.pxToDp(80),
            child: Text(
              content,
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(36)),
            ),
          )),
    ));
  }

  Future<bool> _addMarkerList(
      var markList, var _controller, String type) async {
    if (markList.length > 0) {
      for (int i = 0; i < markList.length + 1; i++) {
        if (i == 0) {
          String orderId = '';
          for (int i = 0; i < markList[0].orderList.length; i++) {
            orderId = orderId + ',${markList[0].orderList[i].orderId}';
          }
          LatLng latLng = LatLng(markList[0].lat, markList[0].lng);
          Marker marker = await _controller?.addMarker(MarkerOption(
            latLng: latLng,
            title: orderId,
            widget: Container(
              width: ScreenUtil().setWidth(50),
              height: AutoLayout.instance.pxToDp(68),
              alignment: Alignment.center,
              child: type == '取'
                  ? Image.asset('images/icon_dark_green_get.png')
                  : type == '送'
                      ? Image.asset('images/icon_dark_yellow_push.png')
                      : Image.asset('images/accept_icon.png'),
            ),
            infoWindowEnabled: false,
          ));
          _markers.add(marker);
        } else {
          String orderId = '';
          for (int j = 0; j < markList[i - 1].orderList.length; j++) {
            orderId = orderId + ',${markList[i - 1].orderList[j].orderId}';
          }
          LatLng latLng = LatLng(markList[i - 1].lat, markList[i - 1].lng);
          _pointList.add(latLng);
          Marker marker = await _controller?.addMarker(MarkerOption(
            visible: true,
            latLng: latLng,
            title: orderId,
            widget: Container(
              width: ScreenUtil().setWidth(50),
              height: AutoLayout.instance.pxToDp(68),
              alignment: Alignment.center,
              child: type == '取'
                  ? Image.asset('images/icon_dark_green_get.png')
                  : type == '送'
                      ? Image.asset('images/icon_dark_yellow_push.png')
                      : Image.asset('images/accept_icon.png'),
            ),
            infoWindowEnabled: false,
          ));
          _markers.add(marker);
        }
      }
    }
    return true;
  }
}
