//订单历史备注数据模型
class MarkHistoryModel {
  int code;
  Data data;
  String message;

  MarkHistoryModel({this.code, this.data, this.message});

  MarkHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<HistoryMarks> historyMarks;

  Data({this.historyMarks});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['historyMarks'] != null) {
      historyMarks = new List<HistoryMarks>();
      json['historyMarks'].forEach((v) {
        historyMarks.add(new HistoryMarks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.historyMarks != null) {
      data['historyMarks'] = this.historyMarks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryMarks {
  String markContent;
  String markTime;

  HistoryMarks({this.markContent, this.markTime});

  HistoryMarks.fromJson(Map<String, dynamic> json) {
    markContent = json['markContent'];
    markTime = json['markTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['markContent'] = this.markContent;
    data['markTime'] = this.markTime;
    return data;
  }
}
