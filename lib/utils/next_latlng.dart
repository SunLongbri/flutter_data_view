import 'dart:math';

import 'package:amap_core_fluttify/amap_core_fluttify.dart';

//mixin NextLatLng {
//  final random = Random(1);
//
//  LatLng getNextLatLng(double lat, double lng) {
//    return LatLng(
//      lat,
//      lng,
//    );
//  }
//}


mixin NextLatLng {
  final random = Random();

  LatLng getNextLatLng({LatLng center}) {
    center ??= LatLng(31.19590, 121.34113);

    return LatLng(
      center.latitude + random.nextDouble(),
      center.longitude + random.nextDouble(),
    );
  }

//  List<LatLng> getNextBatchLatLng(int count) {
//    return [
//      for (int i = 0; i < count; i++)
//        LatLng(
//          39.90960 + random.nextDouble() * 4,
//          116.397228 + random.nextDouble() * 4,
//        )
//    ];
//  }
}
