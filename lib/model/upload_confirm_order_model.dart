//上传确认订单数据模型
class UploadConfirmOrderModel {
  String orderNumber;
  String receiveName;
  String receivePhone;
  String receiveAddress;
  List<SingleGoods> goodsList;
  double totalPrice;

  UploadConfirmOrderModel(
      {this.orderNumber,
        this.receiveName,
        this.receivePhone,
        this.receiveAddress,
        this.goodsList,
        this.totalPrice});

  UploadConfirmOrderModel.fromJson(Map<String, dynamic> json) {
    orderNumber = json['orderNumber'];
    receiveName = json['receiveName'];
    receivePhone = json['receivePhone'];
    receiveAddress = json['receiveAddress'];
    if (json['goodsList'] != null) {
      goodsList = new List<SingleGoods>();
      json['goodsList'].forEach((v) {
        goodsList.add(new SingleGoods.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNumber'] = this.orderNumber;
    data['receiveName'] = this.receiveName;
    data['receivePhone'] = this.receivePhone;
    data['receiveAddress'] = this.receiveAddress;
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}

class SingleGoods {
  String goodsName;
  String goodsCode;
  String goodsParts;
  String goodsMark;
  String id;
  double goodsPrice;
  bool isChildrenType;

  SingleGoods(
      {this.goodsName,
        this.goodsCode,
        this.goodsParts,
        this.goodsMark,
        this.goodsPrice,
        this.id,
        this.isChildrenType});

  SingleGoods.fromJson(Map<String, dynamic> json) {
    goodsName = json['goodsName'];
    goodsCode = json['goodsCode'];
    goodsParts = json['goodsParts'];
    goodsMark = json['goodsMark'];
    goodsPrice = json['goodsPrice'];
    id = json['id'];
    isChildrenType = json['isChildrenType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsName'] = this.goodsName;
    data['goodsCode'] = this.goodsCode;
    data['goodsParts'] = this.goodsParts;
    data['goodsMark'] = this.goodsMark;
    data['goodsPrice'] = this.goodsPrice;
    data['id'] = this.id;
    data['isChildrenType'] = this.isChildrenType;
    return data;
  }
}
