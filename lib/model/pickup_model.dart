//专洗首页地图页返回数据模型
class SpecialWashingModel {
  int code;
  Data data;
  String message;

  SpecialWashingModel({this.code, this.data, this.message});

  SpecialWashingModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<PickUpTaskList> pickUpTaskList;
  List<DeliverTaskList> deliverTaskList;
  List<PickUpTaskList> acceptTaskList;
  TaskInfo taskInfo;

  Data(
      {this.pickUpTaskList,
      this.deliverTaskList,
      this.acceptTaskList,
      this.taskInfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['pickUpTaskList'] != null) {
      pickUpTaskList = new List<PickUpTaskList>();
      json['pickUpTaskList'].forEach((v) {
        pickUpTaskList.add(new PickUpTaskList.fromJson(v));
      });
    }
    if (json['deliverTaskList'] != null) {
      deliverTaskList = new List<DeliverTaskList>();
      json['deliverTaskList'].forEach((v) {
        deliverTaskList.add(new DeliverTaskList.fromJson(v));
      });
    }
    if (json['acceptTaskList'] != null) {
      acceptTaskList = new List<PickUpTaskList>();
      json['acceptTaskList'].forEach((v) {
        acceptTaskList.add(new PickUpTaskList.fromJson(v));
      });
    }
    taskInfo = json['taskInfo'] != null
        ? new TaskInfo.fromJson(json['taskInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickUpTaskList != null) {
      data['pickUpTaskList'] =
          this.pickUpTaskList.map((v) => v.toJson()).toList();
    }
    if (this.deliverTaskList != null) {
      data['deliverTaskList'] =
          this.deliverTaskList.map((v) => v.toJson()).toList();
    }
    if (this.taskInfo != null) {
      data['taskInfo'] = this.taskInfo.toJson();
    }
    return data;
  }
}

class PickUpTaskList {
  double lat;
  double lng;
  String orderType;
  List<OrderList> orderList;

  PickUpTaskList({this.lat, this.lng, this.orderType, this.orderList});

  PickUpTaskList.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    orderType = json['orderType'];
    if (json['orderList'] != null) {
      orderList = new List<OrderList>();
      json['orderList'].forEach((v) {
        orderList.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['orderType'] = this.orderType;
    if (this.orderList != null) {
      data['orderList'] = this.orderList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderList {
  String orderId;

  OrderList({this.orderId});

  OrderList.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    return data;
  }
}

class DeliverTaskList {
  double lat;
  double lng;
  String orderType;
  List<OrderList> orderList;

  DeliverTaskList({this.lat, this.lng, this.orderType, this.orderList});

  DeliverTaskList.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    orderType = json['orderType'];
    if (json['orderList'] != null) {
      orderList = new List<OrderList>();
      json['orderList'].forEach((v) {
        orderList.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['orderType'] = this.orderType;
    if (this.orderList != null) {
      data['orderList'] = this.orderList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskInfo {
  String todayCommission;
  String completed;
  String residueGet;
  String residuePush;
  String residueIn;
  String residueOut;

  TaskInfo(
      {this.todayCommission,
      this.completed,
      this.residueGet,
      this.residuePush,
      this.residueIn,
      this.residueOut});

  TaskInfo.fromJson(Map<String, dynamic> json) {
    todayCommission = json['todayCommission'];
    completed = json['completed'];
    residueGet = json['residueGet'];
    residuePush = json['residuePush'];
    residueIn = json['residueIn'];
    residueOut = json['residueOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todayCommission'] = this.todayCommission;
    data['completed'] = this.completed;
    data['residueGet'] = this.residueGet;
    data['residuePush'] = this.residuePush;
    data['residueIn'] = this.residueIn;
    data['residueOut'] = this.residueOut;
    return data;
  }
}
