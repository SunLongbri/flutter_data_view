import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/select_business.dart';
import 'package:fluttermarketingplus/login/select_role.dart';
import 'package:fluttermarketingplus/model/login_error_model.dart';
import 'package:fluttermarketingplus/model/login_model.dart';
import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';

// import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/permission_request.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/btn_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';

import '../navigator/my_page/show_report_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController;
  TextEditingController _passController;

  //是否加载数据
  bool _isLoading;

  //按钮是否可以被点击
  bool _isClick;
  String _accessToken;

  @override
  void initState() {
    _isClick = true;
    _isLoading = false;
    _nameController = TextEditingController(text: 'meng.ma');
    _passController = TextEditingController(text: 'TidyXiaoGedehoutai');
//    String name = GlobalData.prefs.getString('login_name') ?? '';
//    String pass = GlobalData.prefs.getString('login_pass') ?? '';
//    _nameController = TextEditingController(text: name);
//    _passController = TextEditingController(text: pass);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: LoadingContainer(
          cover: true,
          isLoading: _isLoading,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'images/login_bg.png',
              ),
            )),
            child: Column(
              children: [
                _loginAndPassWidget(),
                BtnWidget(
                  marginTop: AutoLayout.instance.pxToDp(250),
                  marginLeft: ScreenUtil().setWidth(100),
                  marginRignt: ScreenUtil().setWidth(100),
                  btnContent: '登录',
                  onTap: _btnOnTap,
                ),
              ],
            ),
          )),
    );
  }

  //用户名和密码输入框
  Widget _loginAndPassWidget() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headImageWidget(),
          Padding(
              padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(300))),
          _singleInputWidget(
              'images/login_user.png', '请输入用户名', _nameController),
          Padding(
              padding: EdgeInsets.only(top: AutoLayout.instance.pxToDp(40))),
          _singleInputWidget('images/login_pass.png', '请输入密码', _passController),
        ],
      ),
    );
  }

  //登陆按钮的点击事件
  void _btnOnTap() {
    requestPermission();
    if (!_isClick) {
      return;
    }
    String name = _nameController.text.toString().trim();
    String pass = _passController.text.toString().trim();
    GlobalData.prefs.setString('login_name', name);
    GlobalData.prefs.setString('login_pass', pass);

    if (name.isEmpty || pass.isEmpty) {
      showToast('请输入用户名或密码');
      return;
    }
    setState(() {
      _isLoading = true;
      _isClick = false;
    });
    Map<String, String> queryParameters = {'account': name, 'password': pass};

    postRequest(API.LOGIN, queryParameters).then((val) {
      print('登陆穿参:${queryParameters.toString()}');
      print('登陆页返回的结果为:${val}');
      setState(() {
        _isLoading = false;
        _isClick = true;
      });
      LoginModel loginModel = LoginModel.fromJson(val);
      if (loginModel.code == GlobalData.REQUEST_SUCCESS) {
        //返回结果成功
        String accessToken = loginModel.accessToken;
        GlobalData.prefs.setString('accessToken', accessToken);
        String name = loginModel.name;
        String account = loginModel.account;
        List<Menu> menuList = loginModel.menu; //菜单权限
        List<RoleFunction> functionList;
        String role;
        if (menuList.length == 0) {
          showToast('非法用户，拒绝登陆!');
          return;
        }
        for (int i = 0; i < menuList.length; i++) {
          Menu menu = menuList[i];
          if (i == 0) {
            menu.isSelect = '0';
          } else {
            menu.isSelect = '0';
          }
          role = menuList[i].role; //当前角色
          print('role:${role}');
          //用户角色有几种需要存储到本地，因为该app有免密登陆功能，直接跳过登陆页面。
          functionList = menuList[i].roleFunction;
        }

        if (menuList.length == 1) {
          //当前只有一种用户角色，直接跳转到专洗，优洗，快洗等模块
          showToast('当前只有一种用户角色，直接跳转到专洗，优洗，快洗等模块');
          GlobalData.prefs.setBool('isMulti', false);
          GlobalData.prefs.setString('role', role);
          List<String> menuStrList = [];
          for (int j = 0; j < functionList.length; j++) {
            String menuName = functionList[j].menuname; //菜单名称
            print('menuName:${menuName}');
            menuStrList.add(menuName);
          }
          GlobalData.prefs.setStringList('menuStrList', menuStrList);
          //直接跳转到专洗，优洗，快洗等模块
//          Navigator.of(context).pushAndRemoveUntil(
//              new MaterialPageRoute(
//                  builder: (context) => SelectBusiness(
//                        role: menuList.first.role,
//                        fromPage: 'login',
//                      )),
//              (route) => route == null);

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NavigatorIndex()));
        } else if (menuList.length > 1) {
          //用户包含多种角色，跳到用户角色选择页面
          GlobalData.prefs.setBool('isMulti', true);
          showToast('用户包含多种角色，跳到用户角色选择页面');
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (context) => SelectRole(loginModel: loginModel)),
              (route) => route == null);
        }

        print('用户名:${name},密码:${pass}');
        GlobalData.prefs.setString('user_name', name);
        showToast('欢迎,${name}!');
      } else if (loginModel.code == GlobalData.BAD_REQUEST) {
        LoginErrorModel loginErrorModel = LoginErrorModel.fromJson(val);
        showToast(loginErrorModel.message);
      } else if (loginModel.code.toString() == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else {
        setState(() {
          _isClick = true;
        });
        showToast('网络开小车了，请稍后再试');
      }
    });
  }

  //单选输入框组件
  Widget _singleInputWidget(String imageAssets, String hintText,
      TextEditingController textEditingController) {
    //是否为密码类型
    bool type = false;
    if (hintText.contains('密码')) {
      type = true;
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Color(0x30022C42), blurRadius: 20),
          ]),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 50, maxWidth: 330),
        child: TextField(
          controller: textEditingController,
          cursorColor: ColorConstant.hintTextColor,
          obscureText: type,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            hintText: hintText,
            hintStyle: TextStyle(color: ColorConstant.hintTextColor),
            prefixIcon: Container(
              padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(20),
                AutoLayout.instance.pxToDp(25),
                ScreenUtil().setWidth(20),
                AutoLayout.instance.pxToDp(25),
              ),
              child: Image.asset(
                imageAssets,
                fit: BoxFit.fitHeight,
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  //头像组件
  Widget _headImageWidget() {
    return Container(
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(142)),
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(142),
            child: Image.asset('images/login_head.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(20)),
            child: Text(
              '',
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(35)),
            ),
          ),
        ],
      ),
    );
  }
}
