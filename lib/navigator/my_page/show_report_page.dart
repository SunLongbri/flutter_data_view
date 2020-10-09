import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/map_info_model.dart';
import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/next_latlng.dart';
import 'package:fluttermarketingplus/utils/permission_request.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/amap_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';

import '../../login/login_page.dart';
import 'show_report_page/achievement_widget.dart';
import 'show_report_page/amount_distribution_widget.dart';
import 'show_report_page/completion_rate_widget.dart';
import 'show_report_page/my_task_widget.dart';

//实际定位图标
final _assetsIcon = Uri.parse('images/transparent.png');

//小哥端报表页面
class ShowReportPage extends StatefulWidget {
  @override
  _ShowReportPageState createState() => _ShowReportPageState();
}

class _ShowReportPageState extends State<ShowReportPage>
    with NextLatLng, AutomaticKeepAliveClientMixin {
  //地图控制器
  AmapController _controller;

  //marker定位图标
  Uri _assetsLocationIcon = Uri.parse('images/report_location.png');

  ///地图信息展示
  //用户数量
  String _userNum = '';

  //地址
  String _address = '';

  //用户覆盖率
  String _userCover = '';

  //小区品质
  String _houseQuality = '';

  //优质覆盖率
  String _hightLevelCover = '';

  //屏幕的高度
  double deviceHeight;

  @override
  void initState() {
    if (Platform.isIOS) {
      _assetsLocationIcon = null;
    }
    super.initState();
  }

  //地图数据更新
  _getMapLocationData(LatLng latLng) {
//    Map<String, String> queryParameters = {'lat': '44', 'lng': '55'};
    Map<String, String> queryParameters = {
      'lat': latLng.latitude.toString(),
      'lng': latLng.longitude.toString()
    };
    getRequest(API.REPORT_MAP_LOCATION, queryParameters: queryParameters)
        .then((val) async {
      print('登陆页返回的结果为:${val}');
      MapInfoModel mapInfoModel = MapInfoModel.fromJson(val);
      if (mapInfoModel.code == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        Data data = mapInfoModel.data;
        _userNum = data.userNum ?? '';
        _address = data.address ?? '';
        _userCover = '${double.parse(data.userFuGai ?? '0') * 100}%';
        _hightLevelCover = '${double.parse(data.goodUser ?? '0') * 100}%';
        int quality = int.parse(data.quality ?? '0');
        if (quality == 1) {
          _houseQuality = '高端小区';
        } else if (quality == 2) {
          _houseQuality = '普通小区';
        } else if (quality == 3) {
          _houseQuality = '低端小区';
        } else {
          _houseQuality = '未知';
        }
//        final marker = await _controller?.addMarker(
//          MarkerOption(
//            latLng: getNextLatLng(latLng.latitude, latLng.longitude),
//            title: '${_address}:${_houseQuality}',
//            snippet:
//                '用户数:${_userNum} 用户覆盖率:${_userCover} 优质用户覆盖率:${_hightLevelCover}',
////            iconUri: _assetsIcon,
////            imageConfig: createLocalImageConfiguration(context),
////            width: ScreenUtil().setWidth(48),
////            height: ScreenUtil().setWidth(48),
//            object: '自定义数据',
//          ),
//        );
//        marker.showInfoWindow();
      } else if (mapInfoModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else {
        //数据返回失败
        showToast('网络开小车了,请稍后再试!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //获取屏幕的尺寸
    Size deviceSize = MediaQuery.of(context).size;
    deviceHeight = deviceSize.height;
    return Scaffold(
      appBar: AppBarWidget(
        title: '小哥报表',
        actionsWidget: Container(
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(10),
              right: ScreenUtil().setWidth(18)),
          width: ScreenUtil().setWidth(44),
          height: AutoLayout.instance.pxToDp(44),
          child: Image.asset('images/add.png'),
        ),
        actionPress: () {
          JumpReceive().jump(context, Routes.addConsumerPage,
              paramsName: 'data', sendData: '录入客户信息');
        },
      ),
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: DecoratedColumn(
            children: <Widget>[
//              Flexible(
//                flex: 1,
//                child: Stack(
//                  children: [
//                    AmapWidget(
//                      block: (controller) async {
//                        MyLocationOption myLocationOption = MyLocationOption(
//                          strokeColor: Colors.transparent,
//                          strokeWidth: 0.1,
//                          fillColor: Colors.transparent,
//                          show: true,
//                          myLocationType: MyLocationType.Locate,
//                          //只定位
//                          iconProvider: AssetImage('images/icon_location.png'),
//                        );
//                        await controller.showMyLocation(myLocationOption);
//                      },
//                    ),
//                    // SafeArea(child:
//                    Align(
//                      alignment: FractionalOffset(0.5, 0),
//                      child: SafeArea(child: _topBarWidget()),
//                    )
//                    // ),
//                  ],
//                ),
//              ),
              Flexible(
                flex: 2,
                child: DecoratedColumn(
                  scrollable: true,
                  divider: kDividerZero,
                  children: <Widget>[
                    //昨日营收及步行情况
                    AchievementWidget(),
                    AmountDistributionWidget(),
                    _spaceWidget(),
                    MyTaskWidget(),
                    _spaceWidget(),
                    CompleteRateWidget()
                  ],
                ),
              ),
            ],
          )),

//      MediaQuery.removePadding(
//          removeTop: true,
//          context: context,
//          child: SlidingUpPanel(
//            maxHeight: deviceHeight,
//            minHeight: deviceHeight / 2,
//            body: Stack(
//              children: <Widget>[Container(
//                height: deviceHeight / 2,
//                child: _amapViewWidget(),
//              ), _topBarWidget()],
//            ),
//            panelBuilder: (sc) => _panel(sc),
//            parallaxEnabled: true,
//          )),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            //昨日营收及步行情况
            AchievementWidget(),
            AmountDistributionWidget(),
            _spaceWidget(),
            MyTaskWidget(),
            _spaceWidget(),
            CompleteRateWidget()
          ],
        ));
  }

  //空间布件
  Widget _spaceWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(24),
      color: ColorConstant.greyBgColor,
    );
  }

  //地图视图组件
  Widget _amapViewWidget() {
    return AmapView(
      mapType: MapType.Standard,
      showZoomControl: false,
      showCompass: false,
      zoomLevel: 16,
      maskDelay: Duration(milliseconds: 500),
      // 地图创建完成回调 (可选)
      onMapCreated: (controller) async {
        _controller = controller;
        if (await requestPermission()) {
          MyLocationOption myLocationOption = MyLocationOption(
            show: true,
            myLocationType: MyLocationType.Locate, //只定位
//            iconUri: _assetsLocationIcon, //加载本地图片
//            imageConfiguration: createLocalImageConfiguration(context),
          );
          await controller.showMyLocation(myLocationOption);
          LatLng latLng = await _controller?.getLocation();
//          _getMapLocationData(latLng);
        }
      },
    );
  }

  //顶部状态栏组件
  Widget _topBarWidget() {
    return Stack(
      children: [
        Container(
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(120),
          decoration: BoxDecoration(
            color: Color(0x46464646),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _backBtnWidget(),
              Container(
                width: ScreenUtil().setWidth(50),
              ),
              Expanded(
                child: _titleWidget(),
              ),
              _addBtnWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
      child: Text(
        '小哥端',
        style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(35)),
      ),
    );
  }

  //返回按钮组件
  Widget _backBtnWidget() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavigatorIndex()));
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(10),
          left: ScreenUtil().setWidth(18),
        ),
        padding: EdgeInsets.only(
            bottom: AutoLayout.instance.pxToDp(5),
            top: AutoLayout.instance.pxToDp(5)),
        width: ScreenUtil().setWidth(44),
        height: AutoLayout.instance.pxToDp(44),
        child: Image.asset(
          'images/login_back.png',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  //添加客户组件
  Widget _addBtnWidget() {
    return InkWell(
      onTap: () {
        JumpReceive().jump(context, Routes.addConsumerPage,
            paramsName: 'data', sendData: '录入客户信息');
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(10),
            right: ScreenUtil().setWidth(18)),
        width: ScreenUtil().setWidth(44),
        height: AutoLayout.instance.pxToDp(44),
        child: Image.asset('images/add.png'),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
//    print('清除地图中的数据了 ... ');
//    _controller.clear();
    super.dispose();
  }
}

////地图控制器
//extension on AmapController {
//  Future<LatLng> getLocationX() {
//    final interval = const Duration(milliseconds: 500);
//    final timeout = const Duration(seconds: 10);
//    return platform(
//      android: (pool) async {
//        final map = await androidController.getMap();
//        return Stream.periodic(interval, (_) => _)
//            .asyncMap(
//              (count) async {
//                final coord = await map.getMyLocation();
//
//                if (coord == null) {
//                  return null;
//                } else {
//                  return LatLng(await coord.latitude, await coord.longitude);
//                }
//              },
//            )
//            .take(timeout.inMilliseconds ~/ interval.inMilliseconds)
//            .firstWhere((location) => location != null)
//            .timeout(timeout, onTimeout: () => null);
//      },
//      ios: (pool) {
//        return Stream.periodic(interval, (_) => _)
//            .asyncMap(
//              (count) async {
//                final location = await iosController.get_userLocation();
//                final coord = await location.get_coordinate();
//
//                if (coord == null) {
//                  return null;
//                } else {
//                  return LatLng(await coord.latitude, await coord.longitude);
//                }
//              },
//            )
//            .take(timeout.inMilliseconds ~/ interval.inMilliseconds)
//            .firstWhere((location) => location != null)
//            .timeout(timeout, onTimeout: () => null);
//      },
//    );
//  }
//}
