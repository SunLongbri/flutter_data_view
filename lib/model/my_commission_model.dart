//我的佣金数据模型
class MyCommissionModel {
  Data data;
  int status;
  String code;
  String info;

  MyCommissionModel({this.data, this.status, this.info,this.code});

  MyCommissionModel.fromJson(Map<String, dynamic> json) {
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
      list = new List<DataList>();
      json['list'].forEach((v) {
        list.add(new DataList.fromJson(v));
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

class DataList {
  String createDatetime;
  double realcommission;
  double commissionRate;
  double realprice;
  int orderId;

  DataList(
      {this.createDatetime,
        this.realcommission,
        this.commissionRate,
        this.realprice,
        this.orderId});

  DataList.fromJson(Map<String, dynamic> json) {
    createDatetime = json['create_datetime'];
    realcommission = json['realcommission'];
    commissionRate = json['commission_rate'];
    realprice = json['realprice'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_datetime'] = this.createDatetime;
    data['realcommission'] = this.realcommission;
    data['commission_rate'] = this.commissionRate;
    data['realprice'] = this.realprice;
    data['order_id'] = this.orderId;
    return data;
  }
}
