//商品数据模型
class DeliveryOrderGoodModel {
  String goodsName; //商品名称
  String markCode; //商品条码
  String goodsMark; //商品备注
  String isSelect;

  DeliveryOrderGoodModel(
    {
    this.goodsName,
    this.markCode,
    this.goodsMark,
    this.isSelect,
    }
  );

  DeliveryOrderGoodModel.fromJson(Map<String, dynamic> json) {
    
    goodsName = json['goods_name'];
    markCode = json['mark_code'];
    goodsMark = json['goodsMark'];
    isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsName'] = this.goodsName;
    data['markCode'] = this.markCode;
    data['goodsMark'] = this.goodsMark;
    data['isSelect'] = this.isSelect;
    return data;
  }
}


//订单数据模型
class OrderGoodModel {
  String orderId; //订单号或者类别
  List<DeliveryOrderGoodModel> goodsList; //商品列表


  OrderGoodModel(
    {
      this.orderId,
      this.goodsList,
    }
  );

  OrderGoodModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    if (json['item'] != null) {
      goodsList = List<DeliveryOrderGoodModel>();
      json['item'].forEach((v) {
        goodsList.add(DeliveryOrderGoodModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//门店商品类型数据模型
class StoreGoodModel {
  String storeName; //门店名
  List<OrderGoodModel> typeGoodsList; //商品列表


  StoreGoodModel(
    {
    this.storeName,
    this.typeGoodsList,
    }
  );

  StoreGoodModel.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
    if (json['typeGoodsList'] != null) {
      typeGoodsList = List<OrderGoodModel>();
      json['typeGoodsList'].forEach((v) {
        typeGoodsList.add(OrderGoodModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;
    if (this.typeGoodsList != null) {
      data['typeGoodsList'] = this.typeGoodsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryOrderDetailModel {

  int code;
  List<StoreGoodModel> data;

  DeliveryOrderDetailModel({this.code, this.data});

  DeliveryOrderDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<StoreGoodModel>();
      json['data'].forEach((v) {
        data.add(new StoreGoodModel.fromJson(v));
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


class OrderGoodDetailModel {

  int code;
  List<OrderGoodModel> data;

  OrderGoodDetailModel({this.code, this.data});

  OrderGoodDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<OrderGoodModel>();
      json['data'].forEach((v) {
        data.add(new OrderGoodModel.fromJson(v));
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
