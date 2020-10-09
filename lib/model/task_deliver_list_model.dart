//新增任务获取小哥数据列表数据模型
class TaskDeliverListModel {
  List<Data> data;
  int status;
  String code;
  String info;

  TaskDeliverListModel({this.data, this.status, this.info,this.code});

  TaskDeliverListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
    info = json['info'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['info'] = this.info;
    return data;
  }
}

class Data {
  String userId;
  String stationId;
  String nickname;
  String account;

  Data({this.userId, this.stationId, this.nickname, this.account});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    stationId = json['station_id'];
    nickname = json['nickname'];
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['station_id'] = this.stationId;
    data['nickname'] = this.nickname;
    data['account'] = this.account;
    return data;
  }
}
