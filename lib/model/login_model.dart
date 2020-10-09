//登陆的数据模型
class LoginModel {
  String accessToken;
  int code;
  String userId;
  String name;
  List<Menu> menu;
  String account;

  LoginModel(
      {this.accessToken,
        this.code,
        this.userId,
        this.name,
        this.menu,
        this.account});

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    code = json['code'];
    userId = json['user_id'];
    name = json['name'];
    if (json['menu'] != null) {
      menu = new List<Menu>();
      json['menu'].forEach((v) {
        menu.add(new Menu.fromJson(v));
      });
    }
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    if (this.menu != null) {
      data['menu'] = this.menu.map((v) => v.toJson()).toList();
    }
    data['account'] = this.account;
    return data;
  }
}

class Menu {
  String role;
  String isSelect;
  List<RoleFunction> roleFunction;

  Menu({this.role, this.roleFunction});

  Menu.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    if (json['roleFunction'] != null) {
      roleFunction = new List<RoleFunction>();
      json['roleFunction'].forEach((v) {
        roleFunction.add(new RoleFunction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    if (this.roleFunction != null) {
      data['roleFunction'] = this.roleFunction.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoleFunction {
  String menuname;

  RoleFunction({this.menuname});

  RoleFunction.fromJson(Map<String, dynamic> json) {
    menuname = json['menuname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuname'] = this.menuname;
    return data;
  }
}

