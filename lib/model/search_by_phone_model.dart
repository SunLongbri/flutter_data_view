//专洗-搜索- 根据订单号，手机号等进行搜索
import 'order_list_model.dart';

class SearchByPhoneModel {
  int code;
  Data data;
  String message;

  SearchByPhoneModel({this.code, this.data, this.message});

  SearchByPhoneModel.fromJson(Map<String, dynamic> json) {
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
  OrderListByPhone orderListByPhone;

  Data({this.orderListByPhone});

  Data.fromJson(Map<String, dynamic> json) {
    orderListByPhone = json['orderListByPhone'] != null
        ? new OrderListByPhone.fromJson(json['orderListByPhone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderListByPhone != null) {
      data['orderListByPhone'] = this.orderListByPhone.toJson();
    }
    return data;
  }
}

class OrderListByPhone {
  List<OrderDetailList> orderDetailList;

  OrderListByPhone({this.orderDetailList});

  OrderListByPhone.fromJson(Map<String, dynamic> json) {
    if (json['orderDetailList'] != null) {
      orderDetailList = new List<OrderDetailList>();
      json['orderDetailList'].forEach((v) {
        orderDetailList.add(new OrderDetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetailList != null) {
      data['orderDetailList'] =
          this.orderDetailList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


