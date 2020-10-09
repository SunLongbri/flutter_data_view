class DeliveryOrderModel {

  int code;
  List<DeliveryOrderData> data;

  DeliveryOrderModel({this.code, this.data});

  DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<DeliveryOrderData>();
      json['data'].forEach((v) {
        data.add(new DeliveryOrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryOrderData {
  ///交接单id
  String deliveryOrderId;
  ///交接单流程，干线到工厂，干线到门店，工厂到干线，门店到干线
  String source;
  ///交接单发起人
  String createuser;
  ///交接单接收人
  String responser;
  ///交接单交接件数
  String count;
  ///交接单已交接件数
  String receivedCount;
  ///交接单状态
  String status;
  ///交接单发起时间
  String createdate;
  ///交接单接收时间
  String deliveryDate;

  DeliveryOrderData(
    {
      this.deliveryOrderId,
      this.source,
      this.createuser,
      this.responser,
      this.count,
      this.receivedCount,
      this.status,
      this.createdate,
      this.deliveryDate
    }
  );

  DeliveryOrderData.fromJson(Map<String, dynamic> json) {
    deliveryOrderId = json['deliveryOrderId'] != null ? json['deliveryOrderId'] : '';
    source = json['source'] != null ? json['source'] : '';
    createuser = json['createuser'] != null ? json['createuser'] : '';
    responser = json['responser'] != null ? json['responser'] : '';
    count = json['count'] != null ? json['count'] : '';
    receivedCount = json['receivedCount'] != null ? json['receivedCount'] : '';
    status = json['status'] != null ? json['status'] : '';
    createdate = json['createdate'] != null ? json['createdate'] : '';
    deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryOrderId'] = this.deliveryOrderId;
    data['source'] = this.source;
    data['createuser'] = this.createuser;
    data['responser'] = this.responser;
    data['count'] = this.count;
    data['receivedCount'] = this.receivedCount;
    data['status'] = this.status;
    data['createdate'] = this.createdate;
    data['deliveryDate'] = this.deliveryDate;
    return data;
  }
}