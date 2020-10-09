//网点管理报表 达成率 选择菜单数据模型
class DotRateMenuModel {
  List<MenuData> data;
  int status;
  String code;
  String info;

  DotRateMenuModel({this.data, this.status, this.info,this.code});

  DotRateMenuModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<MenuData>();
      json['data'].forEach((v) {
        data.add(new MenuData.fromJson(v));
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

class MenuData {
  String name;
  String id;
  String type;

  MenuData({this.name, this.id, this.type});

  MenuData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}
