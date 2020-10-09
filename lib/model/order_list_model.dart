//订单列表数据模型
class OrderListModel {
  String message;
  List<OrderDetailList> orderDetailList;
  int code;

  OrderListModel({this.message, this.orderDetailList, this.code});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['orderDetailList'] != null) {
      orderDetailList = new List<OrderDetailList>();
      json['orderDetailList'].forEach((v) {
        orderDetailList.add(new OrderDetailList.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.orderDetailList != null) {
      data['orderDetailList'] =
          this.orderDetailList.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class OrderDetailList {
  String placeOrderTime;
  String orderType;
  String orderSource;
  String subscribeTime;
  String customerPhone;
  String orderId;
  String orderPrice;
  List<String> orderWeight;
  String orderStartAddress;
  String orderEndAddress;
  String customerMark;
  String deliverMark;

  OrderDetailList(
      {this.placeOrderTime,
        this.orderType,
        this.orderSource,
        this.subscribeTime,
        this.customerPhone,
        this.orderId,
        this.orderPrice,
        this.orderWeight,
        this.orderStartAddress,
        this.orderEndAddress,
        this.customerMark,
        this.deliverMark});

  OrderDetailList.fromJson(Map<String, dynamic> json) {
    placeOrderTime = json['placeOrderTime'];
    orderType = json['orderType'];
    orderSource = json['orderSource'];
    subscribeTime = json['subscribeTime'];
    orderId = json['orderId'];
    orderWeight = json['orderWeight'].cast<String>();
    orderStartAddress = json['orderStartAddress'];
    orderEndAddress = json['orderEndAddress'];
    customerMark = json['customerMark'];
    deliverMark = json['deliverMark'];
    orderPrice = json['orderPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['placeOrderTime'] = this.placeOrderTime;
    data['orderType'] = this.orderType;
    data['orderSource'] = this.orderSource;
    data['subscribeTime'] = this.subscribeTime;
    data['orderId'] = this.orderId;
    data['orderWeight'] = this.orderWeight;
    data['orderStartAddress'] = this.orderStartAddress;
    data['orderEndAddress'] = this.orderEndAddress;
    data['customerMark'] = this.customerMark;
    data['deliverMark'] = this.deliverMark;
    data['orderPrice'] = this.orderPrice;
    return data;
  }
}
