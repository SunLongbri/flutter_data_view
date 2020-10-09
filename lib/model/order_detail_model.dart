//洗涤订单详情数据模型
class OrderDetailModel {
  int code;
  Data data;
  String message;

  OrderDetailModel({this.code, this.data, this.message});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
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
  WashingDetail washingDetail;

  Data({this.washingDetail});

  Data.fromJson(Map<String, dynamic> json) {
    washingDetail = json['washingDetail'] != null
        ? new WashingDetail.fromJson(json['washingDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.washingDetail != null) {
      data['washingDetail'] = this.washingDetail.toJson();
    }
    return data;
  }
}

class WashingDetail {
  String orderId;
  String orderNumber;
  List<String> orderWeight;
  String orderState;
  String orderSource;
  String workerName;
  String workerNumber;
  String customerName;
  String receiveName;
  String receivePhone;
  String sendPhone;
  String orderStartAddress;
  String orderEndAddress;
  String customerMark;
  String deliverMark;
  String placeOrderTime;
  String subscribeTime;
  String arriveTime;
  List<GoodsList> goodsList;
  String getGoodsTime;
  String signForTime;
  String expectArriveTime;
  String codeSource;
  String codeNum;
  double goodsTotalPrice;
  String goodsPayState;

  WashingDetail(
      {this.orderId,
      this.orderNumber,
      this.orderWeight,
      this.orderState,
      this.orderSource,
      this.workerName,
      this.workerNumber,
      this.customerName,
      this.receivePhone,
      this.receiveName,
      this.sendPhone,
      this.orderStartAddress,
      this.orderEndAddress,
      this.customerMark,
      this.deliverMark,
      this.placeOrderTime,
      this.subscribeTime,
      this.arriveTime,
      this.goodsList,
      this.getGoodsTime,
        this.signForTime,
      this.expectArriveTime,
      this.codeSource,
      this.codeNum,
      this.goodsTotalPrice,
      this.goodsPayState});

  WashingDetail.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderNumber = json['orderNumber'];
    orderWeight = json['orderWeight'].cast<String>();
    orderState = json['orderState'];
    orderSource = json['orderSource'];
    workerName = json['workerName'];
    workerNumber = json['workerNumber'];
    receiveName = json['receiveName'];
    customerName = json['customerName'];
    receivePhone = json['receivePhone'];
    sendPhone = json['sendPhone'];
    orderStartAddress = json['orderStartAddress'];
    orderEndAddress = json['orderEndAddress'];
    customerMark = json['customerMark'];
    deliverMark = json['deliverMark'];
    placeOrderTime = json['placeOrderTime'];
    subscribeTime = json['subscribeTime'];
    arriveTime = json['arriveTime'];
    if (json['goodsList'] != null) {
      goodsList = new List<GoodsList>();
      json['goodsList'].forEach((v) {
        goodsList.add(new GoodsList.fromJson(v));
      });
    }
    getGoodsTime = json['getGoodsTime'];
    signForTime = json['signForTime'];
    expectArriveTime = json['expectArriveTime'];
    codeSource = json['codeSource'];
    codeNum = json['codeNum'];
    goodsTotalPrice = json['goodsTotalPrice'];
    goodsPayState = json['goodsPayState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderNumber'] = this.orderNumber;
    data['orderWeight'] = this.orderWeight;
    data['orderState'] = this.orderState;
    data['orderSource'] = this.orderSource;
    data['workerName'] = this.workerName;
    data['workerNumber'] = this.workerNumber;
    data['customerName'] = this.customerName;
    data['receivePhone'] = this.receivePhone;
    data['sendPhone'] = this.sendPhone;
    data['receiveName'] = this.receiveName;
    data['orderStartAddress'] = this.orderStartAddress;
    data['orderEndAddress'] = this.orderEndAddress;
    data['customerMark'] = this.customerMark;
    data['deliverMark'] = this.deliverMark;
    data['placeOrderTime'] = this.placeOrderTime;
    data['subscribeTime'] = this.subscribeTime;
    data['arriveTime'] = this.arriveTime;
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    data['getGoodsTime'] = this.getGoodsTime;
    data['signForTime'] = this.signForTime;
    data['expectArriveTime'] = this.expectArriveTime;
    data['codeSource'] = this.codeSource;
    data['codeNum'] = this.codeNum;
    data['goodsTotalPrice'] = this.goodsTotalPrice;
    data['goodsPayState'] = this.goodsPayState;
    return data;
  }
}

class GoodsList {
  String goodsName;
  String goodsFlawState;
  String goodsNum;
  String goodsCurrentState;
  double goodsPrice;
  String goodsFlawMark;
  String goodsParts;
  String id;
  List<String> goodsUrl;

  GoodsList(
      {this.goodsName,
      this.goodsFlawState,
      this.goodsNum,
      this.goodsCurrentState,
      this.goodsPrice,
      this.goodsFlawMark,
      this.goodsParts,
      this.id,
      this.goodsUrl});

  GoodsList.fromJson(Map<String, dynamic> json) {
    goodsName = json['goodsName'];
    goodsFlawState = json['goodsFlawState'];
    goodsNum = json['goodsNum'];
    goodsCurrentState = json['goodsCurrentState'];
    goodsPrice = json['goodsPrice'];
    goodsParts = json['goodsParts'];
    goodsFlawMark = json['goodsFlawMark'];
    id = json['id'];
    goodsUrl = json['goodsUrl'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsName'] = this.goodsName;
    data['goodsFlawState'] = this.goodsFlawState;
    data['goodsNum'] = this.goodsNum;
    data['goodsCurrentState'] = this.goodsCurrentState;
    data['goodsPrice'] = this.goodsPrice;
    data['goodsParts'] = this.goodsParts;
    data['goodsFlawMark'] = this.goodsFlawMark;
    data['id'] = this.id;
    data['goodsUrl'] = this.goodsUrl;
    return data;
  }
}
