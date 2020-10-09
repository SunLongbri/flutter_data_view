//商品品类列表数据模型
class GoodsListModel {
  int code;
  Data data;
  String message;

  GoodsListModel({this.code, this.data, this.message});

  GoodsListModel.fromJson(Map<String, dynamic> json) {
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
  List<SingleGoods> goodsList;

  Data({this.goodsList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['goodsList'] != null) {
      goodsList = new List<SingleGoods>();
      json['goodsList'].forEach((v) {
        goodsList.add(new SingleGoods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SingleGoods {
  String imageUrl;
  String goodsId;
  String goodsName;
  String memo;
  String goodsPrice;
  String estimatedWashingTime;
  String order;
  int count;

  SingleGoods(
      {this.imageUrl,
      this.goodsId,
      this.goodsName,
      this.memo,
      this.goodsPrice,
      this.estimatedWashingTime,
      this.order,
      this.count = 0});

  SingleGoods.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    memo = json['memo'];
    goodsPrice = json['goodsPrice'];
    estimatedWashingTime = json['estimatedWashingTime'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['memo'] = this.memo;
    data['goodsPrice'] = this.goodsPrice;
    data['estimatedWashingTime'] = this.estimatedWashingTime;
    data['order'] = this.order;
    return data;
  }
}
