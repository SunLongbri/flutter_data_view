//客户订单所有评价
class CustomerCommentModel {
  Data data;
  int status;
  String code;
  String info;

  CustomerCommentModel({this.data, this.status, this.info,this.code});

  CustomerCommentModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    code = json['code'];
    info = json['info'];
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
  List<SingleComment> list;
  String pagenum;
  bool ispage;

  Data(
      {this.total,
        this.pagesize,
        this.pageindex,
        this.list,
        this.pagenum,
        this.ispage});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pagesize = json['pagesize'];
    pageindex = json['pageindex'];
    if (json['list'] != null) {
      list = List<SingleComment>();
      json['list'].forEach((v) {
        list.add(new SingleComment.fromJson(v));
      });
    }
    pagenum = json['pagenum'];
    ispage = json['ispage'];
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
    return data;
  }
}

class SingleComment {
  String createDatetime;
  String nickname;
  String avatar;
  String info;

  SingleComment({this.createDatetime, this.nickname, this.avatar, this.info});

  SingleComment.fromJson(Map<String, dynamic> json) {
    createDatetime = json['create_datetime'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_datetime'] = this.createDatetime;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['info'] = this.info;
    return data;
  }
}

