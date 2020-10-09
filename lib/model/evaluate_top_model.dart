//好评率排行数据模型
class EvaluateTopModel {
  Data data;
  int status;
  String info;
  String code;

  EvaluateTopModel({this.data, this.status, this.info,this.code});

  EvaluateTopModel.fromJson(Map<String, dynamic> json) {
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
  String total;
  int pagesize;
  int pageindex;
  List<DataList> list;
  String pagenum;
  bool ispage;
  DataList user;

  Data(
      {this.total,
        this.pagesize,
        this.pageindex,
        this.list,
        this.pagenum,
        this.ispage,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pagesize = json['pagesize'];
    pageindex = json['pageindex'];
    if (json['list'] != null) {
      list = List<DataList>();
      json['list'].forEach((v) {
        list.add(new DataList.fromJson(v));
      });
    }
    pagenum = json['pagenum'];
    ispage = json['ispage'];
    user = json['user'] != null ? new DataList.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['pagesize'] = this.pagesize;
    data['pageindex'] = this.pageindex;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['pagenum'] = this.pagenum;
    data['ispage'] = this.ispage;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class DataList {
  String empid;
  int userId;
  double num;
  String nickname;
  String avatar;
  double ratio;

  DataList(
      {this.empid,
        this.userId,
        this.num,
        this.nickname,
        this.avatar,
        this.ratio});

  DataList.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    userId = json['user_id'];
    num = json['num'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    ratio = json['ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empid'] = this.empid;
    data['user_id'] = this.userId;
    data['num'] = this.num;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['ratio'] = this.ratio;
    return data;
  }
}
