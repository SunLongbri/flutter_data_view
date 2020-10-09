//取件路线
class PickUpRouteModel {
  List<PickUpTask> pickUpTaskList;
  String message;
  int code;

  PickUpRouteModel({this.pickUpTaskList, this.message, this.code});

  PickUpRouteModel.fromJson(Map<String, dynamic> json) {
    if (json['pickUpTaskList'] != null) {
      pickUpTaskList = new List<PickUpTask>();
      json['pickUpTaskList'].forEach((v) {
        pickUpTaskList.add(new PickUpTask.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickUpTaskList != null) {
      data['pickUpTaskList'] =
          this.pickUpTaskList.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class PickUpTask {
  int orderType;
  String orderId;
  String orderAddress;
  String orderTime;
  double lng;
  int pickUpIndex;
  double lat;
  String orderMark;
  String receivePhone;
  String receiveName;
  String sendName;
  String sendPhone;

  PickUpTask(
      {this.orderType,
        this.orderId,
        this.orderAddress,
        this.orderTime,
        this.lng,
        this.pickUpIndex,
        this.lat,
        this.orderMark,
      this.receivePhone,
      this.receiveName,
      this.sendName,
      this.sendPhone});

  PickUpTask.fromJson(Map<String, dynamic> json) {
    orderType = json['orderType'];
    orderId = json['orderId'];
    orderAddress = json['orderAddress'];
    orderTime = json['orderTime'];
    lng = json['lng'];
    pickUpIndex = json['pickUpIndex'];
    lat = json['lat'];
    orderMark = json['orderMark'];
    receivePhone = json['receivePhone'];
    receiveName = json['receiveName'];
    sendName = json['sendName'];
    sendPhone = json['sendPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderType'] = this.orderType;
    data['orderId'] = this.orderId;
    data['orderAddress'] = this.orderAddress;
    data['orderTime'] = this.orderTime;
    data['lng'] = this.lng;
    data['pickUpIndex'] = this.pickUpIndex;
    data['lat'] = this.lat;
    data['orderMark'] = this.orderMark;
    data['receivePhone'] = this.receivePhone;
    data['receiveName'] = this.receiveName;
    data['sendName'] = this.sendName;
    data['sendPhone'] = this.sendPhone;
    return data;
  }
}
