//单一订单下对订单进行时间排序的返回结果数据模型
class OrderStrModel {
  int code;
  String message;
  Data data;

  OrderStrModel({this.code, this.message, this.data});

  OrderStrModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<String> sortList;

  Data({this.sortList});

  Data.fromJson(Map<String, dynamic> json) {
    sortList = json['sortList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sortList'] = this.sortList;
    return data;
  }
}
