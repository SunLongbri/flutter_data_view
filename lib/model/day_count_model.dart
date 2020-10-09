//日历-当天数据模型
class DayCountModel {
  int code;
  Data data;
  String message;

  DayCountModel({this.code, this.data, this.message});

  DayCountModel.fromJson(Map<String, dynamic> json) {
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
  GoodsList goodsList;

  Data({this.goodsList});

  Data.fromJson(Map<String, dynamic> json) {
    goodsList = json['goodsList'] != null
        ? new GoodsList.fromJson(json['goodsList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goodsList != null) {
      data['goodsList'] = this.goodsList.toJson();
    }
    return data;
  }
}

class GoodsList {
  int orderCount;
  List<Time> time;

  GoodsList({this.orderCount, this.time});

  GoodsList.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount'];
    if (json['time'] != null) {
      time = new List<Time>();
      json['time'].forEach((v) {
        time.add(new Time.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderCount'] = this.orderCount;
    if (this.time != null) {
      data['time'] = this.time.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Time {
  String timeDetail;
  int wash;
  int flower;

  Time({this.timeDetail, this.wash, this.flower});

  Time.fromJson(Map<String, dynamic> json) {
    timeDetail = json['timeDetail'];
    wash = json['wash'];
    flower = json['flower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timeDetail'] = this.timeDetail;
    data['wash'] = this.wash;
    data['flower'] = this.flower;
    return data;
  }
}
