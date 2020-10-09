import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/permission_request.dart';

class AmapWidget extends StatefulWidget {
  final AmapControllerCallback block;

  const AmapWidget({
    Key key,
    this.block,
  }) : super(key: key);

  @override
  _AmapWidgetState createState() => _AmapWidgetState();
}

class _AmapWidgetState extends State<AmapWidget> {
  @override
  Widget build(BuildContext context) {
    return AmapView(
      autoRelease: false,
      mapType: MapType.Standard,
      showZoomControl: false,
      showCompass: false,
      zoomLevel: 17,
      maskDelay: Duration(milliseconds: 500),
      // 地图创建完成回调 (可选)
      onMapCreated: (controller) async {
        if (await requestPermission()) {
          widget.block(controller);
        }
      },
    );
  }
}
