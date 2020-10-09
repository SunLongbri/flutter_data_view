//我的任务数据模型
class MyTaskModel {
  Data data;
  int status;
  String code;
  String info;

  MyTaskModel({this.data, this.status, this.info, this.code});

  MyTaskModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}

class Data {
  List<TaskData> list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<TaskData>();
      json['list'].forEach((v) {
        list.add(new TaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskData {
  String flowerCount;
  String washMoney;
  int flag;
  String flowerMoney;
  String washCount;

  TaskData(
      {this.flowerCount,
      this.washMoney,
      this.flag,
      this.flowerMoney,
      this.washCount});

  TaskData.fromJson(Map<String, dynamic> json) {
    flowerCount = json['flower_count'];
    washMoney = json['wash_money'];
    flag = json['flag'];
    flowerMoney = json['flower_money'];
    washCount = json['wash_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flower_count'] = this.flowerCount;
    data['wash_money'] = this.washMoney;
    data['flag'] = this.flag;
    data['flower_money'] = this.flowerMoney;
    data['wash_count'] = this.washCount;
    return data;
  }
}
