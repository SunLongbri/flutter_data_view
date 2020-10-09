//优洗-子节点数据模型
class WashTypeChildModel {
  int code;
  Data data;
  String message;

  WashTypeChildModel({this.code, this.data, this.message});

  WashTypeChildModel.fromJson(Map<String, dynamic> json) {
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
  List<GoodsList> goodsList;

  Data({this.goodsList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['goodsList'] != null) {
      goodsList = new List<GoodsList>();
      json['goodsList'].forEach((v) {
        goodsList.add(new GoodsList.fromJson(v));
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

class GoodsList {
  String childTypeName;
  String childTypeId;

  GoodsList({this.childTypeName, this.childTypeId});

  GoodsList.fromJson(Map<String, dynamic> json) {
    childTypeName = json['childTypeName'];
    childTypeId = json['childTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['childTypeName'] = this.childTypeName;
    data['childTypeId'] = this.childTypeId;
    return data;
  }
}
