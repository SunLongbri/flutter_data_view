import 'dart:io';
import 'dart:ui';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/model/deliver_task_model.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/next_latlng.dart';
import 'package:fluttermarketingplus/widgets/amap_widget.dart';
import 'package:fluttermarketingplus/widgets/rotate_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'home_amap_page/order_list_page.dart';
import 'pick_up_pages/washing_detail_page.dart';
import 'pick_up_widgets/pickup_panel_widget.dart';

//取件地图
class PickUpPage extends StatefulWidget {
  final String tabType;

  const PickUpPage({Key key, this.tabType}) : super(key: key);

  @override
  _PickUpPageState createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> with NextLatLng {
  //地图控制器
  AmapController _controller;
  List<Marker> _markers = [];
  DataProvider _dataProvider;
  Polyline _currentPolyline;
  bool _isRotate = false;

  //用户当前坐标
  LatLng userLatLng;

  //当前地图状态
  String currentAmapState;

  //用于缩放所有的取送标记
  List<LatLng> _pointList = [];

  //panel
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 240.0;
  PickUpRouteModel pickUpRouteModel;

  String tabLeftImg = '';
  String tabRightImg = '';

  @override
  void initState() {
    super.initState();
    currentAmapState = widget.tabType;
    if (widget.tabType == '取') {
      tabLeftImg = 'images/tab_push_unselect.png';
      tabRightImg = 'images/tab_pickup_select.png';
    } else if (widget.tabType == '送') {
      tabLeftImg = 'images/tab_push_select.png';
      tabRightImg = 'images/tab_pickup_unselect.png';
    }
    _fabHeight = _panelHeightClosed + 20;
  }

  void _refreshPickUpData() async {
    _currentPolyline?.remove();
    await _controller.clearMarkers(_markers);
    _pointList.clear();
    _pointList.add(userLatLng);
    getRequest(API.PICKUP_TASK, tempBaseUrl: API.TEST_BASE_URL).then((val) {
      print('取件地图val:${val}');
      _dataProvider.isRefresh = false;
      pickUpRouteModel = PickUpRouteModel.fromJson(val);
      if (pickUpRouteModel.code == 200) {
        setState(() {
          pickUpRouteModel = PickUpRouteModel.fromJson(val);
          _dataProvider.setPickUpTaskList = pickUpRouteModel.pickUpTaskList;
        });
        _addMarkers();
      } else {
        showToast('服务异常.....');
      }
    });
  }

  //tab切换刷新数据
  void _tabSwitchRefreshData() {
    var formData = {
      "deliverLocation": {
        "lat": userLatLng.latitude ?? '',
        "lng": userLatLng.longitude ?? ''
      }
    };
    postRequest(API.DELIVER_TASK, formData, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) async {
      print('送件地图formData:${formData}');
      print('送件地图接收到的数据:${value}');
      DeliverTaskModel deliverTaskModel = DeliverTaskModel.fromJson(value);
      if (deliverTaskModel.code != 200) {
        showToast('网络连接失败!');
        return;
      }
      _dataProvider.setPickUpTaskList = deliverTaskModel.deliverTaskList;
      _currentPolyline?.remove();
      await _controller.clearMarkers(_markers);
      _pointList.clear();
      _pointList.add(userLatLng);
      List<PickUpTask> pickUpList = deliverTaskModel.deliverTaskList;
      for (int i = 0; i < pickUpList.length; i++) {
        LatLng latLng = LatLng(pickUpList[i].lat, pickUpList[i].lng);
        _pointList.add(latLng);
        if (i == 0) {
          Marker marker = await _controller?.addMarker(MarkerOption(
            anchorV: 0.9,
            latLng: latLng,
            widget: Container(
              width: ScreenUtil().setWidth(50),
              height: AutoLayout.instance.pxToDp(68),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(12)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  'images/yellow_empty.png',
                ),
              )),
              child: Text(
                '${(i + 1).toString()}',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(25)),
              ),
            ),
            infoWindowEnabled: false,
          ));
          _markers.add(marker);
        }
        Marker marker = await _controller?.addMarker(MarkerOption(
          anchorV: 0.9,
          latLng: latLng,
          widget: Container(
            width: ScreenUtil().setWidth(50),
            height: AutoLayout.instance.pxToDp(68),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(12)),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                'images/yellow_empty.png',
              ),
            )),
            child: Text(
              '${(i + 1).toString()}',
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(25)),
            ),
          ),
          infoWindowEnabled: false,
        ));
        _markers.add(marker);
      }
      _controller?.zoomToSpan(
        _pointList,
        padding: EdgeInsets.only(bottom: 250, left: 50, right: 50, top: 80),
      );

      _currentPolyline = await _controller?.addPolyline(PolylineOption(
        latLngList: _pointList,
        width: 10,
        strokeColor: Color(0xffEA9B48),
      ));

      Future.delayed(Duration(milliseconds: 2000)).then((e) {
        _controller?.setMarkerClickedListener((marker) async {
          String title = await marker.title;
          print('送件列表：${title}');
//          if (title.contains(',')) {
//            //该订单有多个订单
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => OrderListPage(
//                      orderStr: title,
//                    )));
//          } else {
//            //该订单只有一个订单
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => WashingDetailPage(
//                      washingId: title,
//                    )));
//          }
          return true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    _panelHeightOpen = MediaQuery.of(context).size.height * .90;
    bool parallax = true;
    if (Platform.isIOS) {
      parallax = false;
    } else if (Platform.isAndroid) {
      parallax = true;
    }
    if (_dataProvider.isRefresh) {
      _refreshPickUpData();
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: parallax,
              parallaxOffset: .5,
              panelBuilder: (sc) => PickUpPanelWidget(
                scrollController: sc,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * _panelHeightClosed + _panelHeightClosed + 20;
                if (pos == 1) {
                  _fabHeight = _panelHeightOpen + _panelHeightClosed;
                }
              }),
              body: Container(
                child: Stack(
                  children: <Widget>[
                    AmapWidget(
                      block: (controller) {
                        _controller = controller;
                        Future.delayed(Duration(milliseconds: 100))
                            .then((value) async {
                          MyLocationOption myLocationOption = MyLocationOption(
                            strokeColor: Colors.transparent,
                            strokeWidth: 0.1,
                            fillColor: Colors.transparent,
                            show: true,
                            myLocationType: MyLocationType.Locate,
                            //只定位
                            iconProvider: AssetImage('images/car.png'),
                          );
                          await controller.showMyLocation(myLocationOption);
                          userLatLng = await _controller?.getLocation();
                          _pointList.add(userLatLng);
                          if (currentAmapState == '取') {
                            _refreshPickUpData();
                          } else if (currentAmapState == '送') {
                            _tabSwitchRefreshData();
                          }
                        });
                      },
                    ),
                    Positioned(
                      left: 10.0,
                      bottom: _fabHeight,
                      child: _refreshDataWidget(),
                    ),
                    Positioned(
                      left: 10.0,
                      top: 50.0,
                      child: _backBtnWidget(),
                    ),
                    Positioned(
                        right: 10.0,
                        bottom: _fabHeight,
                        child: _tabSwitchWidget())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //取送件页面切换按钮
  Widget _tabSwitchWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              if (tabLeftImg.contains('un')) {
                //左侧之前未点击，用户当前点击
                setState(() {
                  tabLeftImg = 'images/tab_push_select.png';
                  tabRightImg = 'images/tab_pickup_unselect.png';
                });
                print('当前切换到送件地图。。。');
                currentAmapState = '送';
                _tabSwitchRefreshData();
              }
              //当前点击左侧送件Tab按钮
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: ScreenUtil().setWidth(96),
              child: Image.asset(
                tabLeftImg,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (tabRightImg.contains('un')) {
                  //右侧之前未点击，用户当前点击
                  tabRightImg = 'images/tab_pickup_select.png';
                  tabLeftImg = 'images/tab_push_unselect.png';
                  print('当前切换到取件地图。。。');
                  currentAmapState = '取';
                  _refreshPickUpData();
                }
              });
              //当前点击右侧取件Tab按钮
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: ScreenUtil().setWidth(96),
              child: Image.asset(
                tabRightImg,
                fit: BoxFit.fitWidth,
              ),
            ),
          )
        ],
      ),
    );
  }

  //返回按钮
  Widget _backBtnWidget() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: ScreenUtil().setWidth(82),
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(76),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Color(0x30022C42), blurRadius: 20),
            ]),
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(16),
        ),
        child: Image.asset(
          'images/back_blue.png',
          width: ScreenUtil().setWidth(24),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _refreshDataWidget() {
    return Container(
      child: InkWell(
          onTap: () {
            setState(() {
              _isRotate = true;
            });
            Future.delayed(Duration(milliseconds: 2000)).then((value) async {
              setState(() {
                _isRotate = false;
              });
            });
            //请求数据
            if (currentAmapState == '取') {
              _refreshMarkers();
            } else if (currentAmapState == '送') {
              _tabSwitchRefreshData();
            }
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

  _refreshMarkers() async {
    _currentPolyline?.remove();
    await _controller.clearMarkers(_markers);
    _pointList.clear();
    _refreshPickUpData();
  }

  _addMarkers() async {
    List<PickUpTask> pickUpTaskList = pickUpRouteModel.pickUpTaskList;
    if (pickUpTaskList.length > 0) {
      for (int i = 0; i < pickUpTaskList.length + 1; i++) {
        if (i == 0) {
          LatLng latLng = LatLng(pickUpTaskList[i].lat, pickUpTaskList[i].lng);
          if (pickUpTaskList[i].orderType == 2) {
            _pointList.add(latLng);
          }
          Marker marker = await _controller?.addMarker(MarkerOption(
            anchorV: 0.9,
            latLng: latLng,
            widget: Container(
              width: ScreenUtil().setWidth(50),
              height: AutoLayout.instance.pxToDp(68),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(12)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  pickUpTaskList[i].orderType == 1
                      ? 'images/accept_icon.png'
                      : 'images/get_empty.png',
                ),
              )),
              child: Text(
                pickUpTaskList[i].orderType == 1
                    ? ''
                    : pickUpTaskList[i].pickUpIndex.toString(),
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(25)),
              ),
            ),
            infoWindowEnabled: false,
          ));
          _markers.add(marker);
        } else {
          LatLng latLng =
              LatLng(pickUpTaskList[i - 1].lat, pickUpTaskList[i - 1].lng);

          if (pickUpTaskList[i - 1].orderType == 2) {
            _pointList.add(latLng);
          }
          Marker marker = await _controller?.addMarker(MarkerOption(
            anchorV: 0.9,
            latLng: latLng,
            widget: Container(
              width: ScreenUtil().setWidth(50),
              height: AutoLayout.instance.pxToDp(68),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(12)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  pickUpTaskList[i - 1].orderType == 1
                      ? 'images/accept_icon.png'
                      : 'images/get_empty.png',
                ),
              )),
              child: Text(
                pickUpTaskList[i - 1].orderType == 1
                    ? ''
                    : pickUpTaskList[i - 1].pickUpIndex.toString(),
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(25)),
              ),
            ),
            infoWindowEnabled: false,
          ));
          _markers.add(marker);
        }
      }
//      _dataProvider.setAmapMarkers = _markers;
      _controller?.zoomToSpan(
        _pointList,
        padding: EdgeInsets.only(bottom: 250, left: 50, right: 50, top: 80),
      );

      _currentPolyline = await _controller?.addPolyline(PolylineOption(
        latLngList: _pointList,
        width: 10,
        strokeColor: Color(0xff35C7BA),
      ));

      Future.delayed(Duration(milliseconds: 2000)).then((e) {
        _controller?.setMarkerClickedListener((marker) async {
          String title = await marker.title;
          print('送件列表：${title}');
//          if (title.contains(',')) {
//            //该订单有多个订单
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => OrderListPage(
//                      orderStr: title,
//                    )));
//          } else {
//            //该订单只有一个订单
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => WashingDetailPage(
//                      washingId: title,
//                    )));
//          }
          return true;
        });
      });
    }
  }
}
