import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/select_business.dart';
import 'package:fluttermarketingplus/model/login_model.dart';
import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';
import 'package:fluttermarketingplus/navigator/store_navigator_index.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:oktoast/oktoast.dart';

///选择角色界面
class SelectRole extends StatefulWidget {
  LoginModel loginModel;

  SelectRole({Key key, this.loginModel}) : super(key: key);

  @override
  _SelectRoleState createState() => _SelectRoleState();
}

class _SelectRoleState extends State<SelectRole> {
  LoginModel _loginModel;
  List<Menu> _menuList;

  @override
  void initState() {
    super.initState();
    _loginModel = widget.loginModel;
    _menuList = _loginModel.menu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            //标题
            SizedBox(
              height: 100,
            ),
            Container(
              height: 44,
              child: Text(
                '请选择您的角色',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
            ),
            Expanded(
              //列表
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _listViewBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //列表控件
  Widget _listViewBuilder() {
    return Container(
      child: ListView.builder(
        itemCount: _menuList.length,
        itemBuilder: _listItemBuilder,
      ),
    );
  }

//列表 cell
  Widget _listItemBuilder(BuildContext context, int index) {
    Menu menu = _menuList[index];
    return GestureDetector(
        onTap: () {
          List<RoleFunction> _roleFunction =
              _loginModel.menu[index].roleFunction;
          List<String> menuStrList = [];
          for (int j = 0; j < _roleFunction.length; j++) {
            String menuName = _roleFunction[j].menuname; //菜单名称
            print('menuName:${menuName}');
            menuStrList.add(menuName);
          }
          GlobalData.prefs.setStringList('menuStrList', menuStrList);
//          Navigator.of(context)
//              .push(MaterialPageRoute(builder: (context) => SelectBusiness(role: menu.role,fromPage: 'selectRole',)));
          if (menu.role == '小哥') {
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => NavigatorIndex()),
                (route) => route == null);
            //todo：此处需要修改为门店
          } else if(menu.role == '工厂'){
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => StoreNavigatorIndex()),
                    (route) => route == null);
          }else {
            showToast('当前功能敬请期待！');
          }

          print(menu.roleFunction);

          for (Menu menu1 in _menuList) {
            menu1.isSelect = '0';
          }
          menu.isSelect = '1';
          setState(() {});
        },
        child: Container(
          width: 100,
          height: 150,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              //头像
              Container(
                width: 100,
                height: 100,
                child:
                    Image.asset('images/' + menu.role + menu.isSelect + '.png'),
              ),
              SizedBox(
                height: 10.0,
              ),
              //名称
              Expanded(
                  flex: 3,
                  child: Text(
                    menu.role,
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ));
  }
}
