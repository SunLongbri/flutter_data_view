//网点业绩排名
class StationListModel {
  Data data;
  int status;
  String info;
  String code;

  StationListModel({this.data, this.status, this.info,this.code});

  StationListModel.fromJson(Map<String, dynamic> json) {
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
  Station station;
  Page page;

  Data({this.station, this.page});

  Data.fromJson(Map<String, dynamic> json) {
    station =
        json['station'] != null ? new Station.fromJson(json['station']) : null;
    page = json['page'] != null ? new Page.fromJson(json['page']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.station != null) {
      data['station'] = this.station.toJson();
    }
    if (this.page != null) {
      data['page'] = this.page.toJson();
    }
    return data;
  }
}

class Station {
  double price;
  String num;
  String name;
  int count;
  double commission;
  String type;
  int serverId;

  Station(
      {this.price,
      this.num,
      this.name,
      this.count,
      this.commission,
      this.type,
      this.serverId});

  Station.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    num = json['num'];
    name = json['name'];
    count = json['count'];
    commission = json['commission'];
    type = json['type'];
    serverId = json['server_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['num'] = this.num;
    data['name'] = this.name;
    data['count'] = this.count;
    data['commission'] = this.commission;
    data['type'] = this.type;
    data['server_id'] = this.serverId;
    return data;
  }
}

class Page {
  String total;
  String pagesize;
  String pageindex;
  List<Station> list;
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
      list = List<Station>();
      json['list'].forEach((v) {
        list.add(Station.fromJson(v));
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
