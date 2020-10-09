//绑定衣物并上传衣物数据模型
class BindClothesModel {
  String orderId;
  String type;
  String goodsCid;
  String goodsId;
  String goodsName;
  double goodsPrice;
  String goodsCode;
  List<String> goodsFlaw;
  String goodsMark;
  String goodsParts;

  BindClothesModel(
      {this.orderId,
      this.type,
      this.goodsCid,
      this.goodsId,
      this.goodsName,
      this.goodsPrice,
      this.goodsCode,
      this.goodsFlaw,
      this.goodsMark,
      this.goodsParts});

  BindClothesModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    type = json['type'];
    goodsCid = json['goodsCid'];
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    goodsPrice = json['goodsPrice'];
    goodsCode = json['goodsCode'];
    goodsFlaw = json['goodsFlaw'].cast<String>();
    goodsMark = json['goodsMark'];
    goodsParts = json['goodsParts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['type'] = this.type;
    data['goodsCid'] = this.goodsCid;
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['goodsPrice'] = this.goodsPrice;
    data['goodsCode'] = this.goodsCode;
    data['goodsFlaw'] = this.goodsFlaw;
    data['goodsMark'] = this.goodsMark;
    data['goodsParts'] = this.goodsParts;
    return data;
  }

}
