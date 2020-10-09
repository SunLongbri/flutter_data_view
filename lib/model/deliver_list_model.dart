//小哥业绩排名数据模型
class DeliverListModel {
  Data data;
  int status;
  String code;
  String info;

  DeliverListModel({this.data, this.status, this.info});

  DeliverListModel.fromJson(Map<String, dynamic> json) {
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
  List<Deliver> station;
  Page page;

  Data({this.station, this.page});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['station'] != null) {
      station = new List<Deliver>();
      json['station'].forEach((v) {
        station.add(new Deliver.fromJson(v));
      });
    }
    page = json['page'] != null ? new Page.fromJson(json['page']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.station != null) {
      data['station'] = this.station.map((v) => v.toJson()).toList();
    }
    if (this.page != null) {
      data['page'] = this.page.toJson();
    }
    return data;
  }
}

class Deliver {
  double price;
  String num;
  String name;
  int count;
  double commission;
  int serverId;

  Deliver(
      {this.price,
      this.num,
      this.name,
      this.count,
      this.commission,
      this.serverId});

  Deliver.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    num = json['num'];
    name = json['name'];
    count = json['count'];
    commission = json['commission'];
    serverId = json['server_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['num'] = this.num;
    data['name'] = this.name;
    data['count'] = this.count;
    data['commission'] = this.commission;
    data['server_id'] = this.serverId;
    return data;
  }
}

class Page {
  String total;
  String pagesize;
  String pageindex;
  List<Deliver> list;
  String pagenum;
  bool ispage;

  Page(
      {this.total,
      this.pagesize,
      this.pageindex,
      this.list,
      this.pagenum,
      this.ispage});

  Page.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pagesize = json['pagesize'];
    pageindex = json['pageindex'];
    if (json['list'] != null) {
      list = new List<Deliver>();
      json['list'].forEach((v) {
        list.add(new Deliver.fromJson(v));
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
