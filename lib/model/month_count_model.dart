//日历-月份数据模型
class MonthCountModel {
  int code;
  Data data;
  String message;

  MonthCountModel({this.code, this.data, this.message});

  MonthCountModel.fromJson(Map<String, dynamic> json) {
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
  List<MonthDay> goodsList;

  Data({this.goodsList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['goodsList'] != null) {
      goodsList = new List<MonthDay>();
      json['goodsList'].forEach((v) {
        goodsList.add(new MonthDay.fromJson(v));
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

class MonthDay {
  int orderCount;
  int dateDifferent;

  MonthDay({this.orderCount, this.dateDifferent});

  MonthDay.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount'];
    dateDifferent = json['dateDifferent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderCount'] = this.orderCount;
    data['dateDifferent'] = this.dateDifferent;
    return data;
  }
}
