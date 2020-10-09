import 'package:decorated_flutter/decorated_flutter.dart';

class DataJson {
  static Map<String, dynamic> HOME_MAP_JSON = {
    "code": "200",
    "data": {
      "pickUpTaskList": [
        {
          "lat": 31.19590,
          "lng": 121.34,
          "orderType": "取",
          "orderList": [
            {"orderId": "0000001"},
            {"orderId": "0000002"}
          ]
        },
        {
          "lat": 31.19590,
          "lng": 121.36,
          "orderType": "取",
          "orderList": [
            {"orderId": "0000003"},
            {"orderId": "0000004"}
          ]
        }
      ],
      "deliverTaskList": [
        {
          "lat": 31.2,
          "lng": 121.34,
          "orderType": "送",
          "orderList": [
            {"orderId": "0000005"},
            {"orderId": "0000006"}
          ]
        },
        {
          "lat": 31.19590,
          "lng": 121.40,
          "orderType": "送",
          "orderList": [
            {"orderId": "0000007"},
            {"orderId": "0000008"}
          ]
        }
      ],
      "acceptTaskList": [
        {
          "lat": 31.19590,
          "lng": 121.32,
          "orderType": "受",
          "orderList": [
            {"orderId": "0000009"},
            {"orderId": "0000010"}
          ]
        },
        {
          "lat": 31.19590,
          "lng": 121.30,
          "orderType": "受",
          "orderList": [
            {"orderId": "0000011"},
            {"orderId": "0000012"}
          ]
        }
      ],
      "taskInfo": {
        "todayCommission": "¥100.00",
        "completed": "5单",
        "residueGet": "6",
        "residuePush": "8",
        "residueIn": "15",
        "residueOut": "24"
      }
    },
    "message": "操作成功"
  };
}
