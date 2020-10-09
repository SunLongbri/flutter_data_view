//新增任务上传数据模型
class AddTaskUploadModel {
  String flag;
  String stationId;
  List<Task> task;

  AddTaskUploadModel({this.flag, this.stationId, this.task});

  AddTaskUploadModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    stationId = json['station_id'];
    if (json['task'] != null) {
      task = new List<Task>();
      json['task'].forEach((v) {
        task.add(new Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['station_id'] = this.stationId;
    if (this.task != null) {
      data['task'] = this.task.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String userId;
  String userName;
  String flowerCount;
  String flowerMoney;
  String washCount;
  String washMoney;

  Task(
      {this.userId,
      this.userName,
      this.flowerCount,
      this.flowerMoney,
      this.washCount,
      this.washMoney});

  Task.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    flowerCount = json['flower_count'];
    flowerMoney = json['flower_money'];
    washCount = json['wash_count'];
    washMoney = json['wash_money'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['flower_count'] = this.flowerCount;
    data['flower_money'] = this.flowerMoney;
    data['wash_count'] = this.washCount;
    data['wash_money'] = this.washMoney;
    return data;
  }
}
