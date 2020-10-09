import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/model/pickup_model.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/home_amap_page/order_list_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_page.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/next_latlng.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../widgets/amap_widget.dart';

class HomeAmapWidget extends StatefulWidget {
  @override
  _HomeAmapWidgetState createState() => _HomeAmapWidgetState();
}

class _HomeAmapWidgetState extends State<HomeAmapWidget> with NextLatLng {
  //地图控制器
  AmapController _controller;

  //取送件的所有标记
  List<Marker> _markers = [];

  //用于缩放所有的取送标记
  List<LatLng> _pointList = [];
  DataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of(context);
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: AmapWidget(
        block: (controller) {
          _controller = controller;
          _dataProvider.setAmapController = controller;
          Future.delayed(Duration(milliseconds: 1000)).then((value) async {
            MyLocationOption myLocationOption = MyLocationOption(
              strokeColor: Colors.transparent,
              strokeWidth: 0.1,
              fillColor: Colors.transparent,
              show: true,
              myLocationType: MyLocationType.Locate,
              //只定位
              iconProvider: AssetImage('images/icon_location.png'),
            );
            await controller.showMyLocation(myLocationOption);
            LatLng latLng = await _controller?.getLocation();
            _pointList.add(latLng);
            _addMarkers();
          });
        },
      ),
    );
  }

  _addMarkers() async {
    SpecialWashingModel specialWashingModel =
        _dataProvider.getSpecialWashingModel;
    if (specialWashingModel != null) {
      List<PickUpTaskList> pickUpTaskList =
          specialWashingModel.data.pickUpTaskList;
      List<DeliverTaskList> deliverTaskList =
          specialWashingModel.data.deliverTaskList;
      List<PickUpTaskList> acceptTaskList =
          specialWashingModel.data.acceptTaskList;

      _addMarkerList(pickUpTaskList, '取').then((val) {
        _addMarkerList(deliverTaskList, '送').then((val) {
          _addMarkerList(acceptTaskList, '受').then((val) {
            _dataProvider.setAmapMarkers = _markers;
            _controller?.zoomToSpan(
              _pointList,
              padding:
                  EdgeInsets.only(bottom: 270, left: 50, right: 50, top: 80),
            );
            Future.delayed(Duration(milliseconds: 2000)).then((e) {
              _controller?.setMarkerClickedListener((marker) async {
                String title = await marker.title;
                title = title.substring(1, title.length);
                print('title:${title}');
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
  }

  Future<bool> _addMarkerList(var markList, String type) async {
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
