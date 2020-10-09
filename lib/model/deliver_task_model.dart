//送件地图返回数据模型
import 'package:fluttermarketingplus/model/pickup_route_model.dart';

class DeliverTaskModel {
  String message;
  int code;
  List<PickUpTask> deliverTaskList;

  DeliverTaskModel({this.message, this.code, this.deliverTaskList});

  DeliverTaskModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    if (json['deliverTaskList'] != null) {
      deliverTaskList = new List<PickUpTask>();
      json['deliverTaskList'].forEach((v) {
        deliverTaskList.add(new PickUpTask.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.deliverTaskList != null) {
      data['deliverTaskList'] =
          this.deliverTaskList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliverTaskList {
  String orderAddress;
  String orderTime;
  double lng;
  String orderId;
  double lat;
  String orderMark;

  DeliverTaskList(
      {this.orderAddress,
        this.orderTime,
        this.lng,
        this.orderId,
        this.lat,
        this.orderMark});

  DeliverTaskList.fromJson(Map<String, dynamic> json) {
    orderAddress = json['orderAddress'];
    orderTime = json['orderTime'];
    lng = json['lng'];
    orderId = json['orderId'];
    lat = json['lat'];
    orderMark = json['orderMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderAddress'] = this.orderAddress;
    data['orderTime'] = this.orderTime;
    data['lng'] = this.lng;
    data['orderId'] = this.orderId;
    data['lat'] = this.lat;
    data['orderMark'] = this.orderMark;
    return data;
  }
}
