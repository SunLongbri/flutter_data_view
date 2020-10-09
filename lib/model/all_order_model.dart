//全部订单数据模型
class AllOrderModel {
  int code;
  Data data;
  String message;

  AllOrderModel({this.code, this.data, this.message});

  AllOrderModel.fromJson(Map<String, dynamic> json) {
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
  List<String> orderAcceptedData;
  List<String> orderInProgressData;
  List<String> orderSignedInData;
  List<String> orderNotAcceptedData;
  List<String> alreadyGetOrder;

  Data(
      {this.orderAcceptedData,
        this.orderInProgressData,
        this.orderSignedInData,
        this.orderNotAcceptedData,this.alreadyGetOrder});

  Data.fromJson(Map<String, dynamic> json) {
    orderAcceptedData = json['orderAcceptedData'].cast<String>();
    orderInProgressData = json['orderInProgressData'].cast<String>();
    orderSignedInData = json['orderSignedInData'].cast<String>();
    orderNotAcceptedData = json['orderNotAcceptedData'].cast<String>();
    alreadyGetOrder = json['alreadyGetOrder'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['orderAcceptedData'] = this.orderAcceptedData;
    data['orderInProgressData'] = this.orderInProgressData;
    data['orderSignedInData'] = this.orderSignedInData;
    data['orderNotAcceptedData'] = this.orderNotAcceptedData;
    data['alreadyGetOrder'] = this.alreadyGetOrder;

    return data;
  }
}
