//昨日战况返回数据模型
class YesterdayWarInfoModel {
  Data data;
  int status;
  String code;
  String info;

  YesterdayWarInfoModel({this.data, this.status, this.info,this.code});

  YesterdayWarInfoModel.fromJson(Map<String, dynamic> json) {
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
  List<Query> query;
  List<DataList> list;
  User user;

  Data({this.query, this.list, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['query'] != null) {
      query = new List<Query>();
      json['query'].forEach((v) {
        query.add(new Query.fromJson(v));
      });
    }
    if (json['list'] != null) {
      list = new List<DataList>();
      json['list'].forEach((v) {
        list.add(new DataList.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.query != null) {
      data['query'] = this.query.map((v) => v.toJson()).toList();
    }
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Query {
  int num;
  double realcommission;
  int type;
  double realprice;

  Query({this.num, this.realcommission, this.type, this.realprice});

  Query.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    realcommission = json['realcommission'];
    type = json['type'];
    realprice = json['realprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['realcommission'] = this.realcommission;
    data['type'] = this.type;
    data['realprice'] = this.realprice;
    return data;
  }
}

class DataList {
  String createDatetime;
  String info;

  DataList({this.createDatetime, this.info});

  DataList.fromJson(Map<String, dynamic> json) {
    createDatetime = json['create_datetime'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_datetime'] = this.createDatetime;
    data['info'] = this.info;
    return data;
  }
}

class User {
  String empid;
  int userId;
  double num;
  String nickname;
  String avatar;
  double ratio;

  User(
      {this.empid,
        this.userId,
        this.num,
        this.nickname,
        this.avatar,
        this.ratio});

  User.fromJson(Map<String, dynamic> json) {
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
