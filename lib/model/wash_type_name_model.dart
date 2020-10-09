//优洗 - 第一级 - 名字数据模型
class WashTypeNameModel {
  int code;
  Data data;
  String message;

  WashTypeNameModel({this.code, this.data, this.message});

  WashTypeNameModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<BannerList> bannerList;
  TypeDescription typeDescription;
  List<TypeList> typeList;

  Data({this.bannerList, this.typeDescription, this.typeList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = new List<BannerList>();
      json['bannerList'].forEach((v) {
        bannerList.add(new BannerList.fromJson(v));
      });
    }
    typeDescription = json['typeDescription'] != null
        ? new TypeDescription.fromJson(json['typeDescription'])
        : null;
    if (json['typeList'] != null) {
      typeList = new List<TypeList>();
      json['typeList'].forEach((v) {
        typeList.add(new TypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    }
    if (this.typeDescription != null) {
      data['typeDescription'] = this.typeDescription.toJson();
    }
    if (this.typeList != null) {
      data['typeList'] = this.typeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerList {
  String imageUrl;
  Null webUrl;

  BannerList({this.imageUrl, this.webUrl});

  BannerList.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    webUrl = json['webUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['webUrl'] = this.webUrl;
    return data;
  }
}

class TypeDescription {
  String description;
  String title;

  TypeDescription({this.description, this.title});

  TypeDescription.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['title'] = this.title;
    return data;
  }
}

class TypeList {
  String imageUrl;
  String type;

  TypeList({this.imageUrl, this.type});

  TypeList.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['type'] = this.type;
    return data;
  }
}
