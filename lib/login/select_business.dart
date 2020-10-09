import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/navigator/special_navigator_index.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:oktoast/oktoast.dart';

class SelectBusiness extends StatefulWidget {
  String role; //角色
  String fromPage; //跳转过的界面 selectRole 多角色  login单角色
  SelectBusiness({Key key, this.role, this.fromPage}) : super(key: key);

  @override
  _SelectBusinessState createState() => _SelectBusinessState();
}

class _SelectBusinessState extends State<SelectBusiness> {
  String _role;
  String _fromPage;
  List<String> _businessList;

  bool isMulti;

  @override
  void initState() {
    super.initState();
    _role = widget.role;
    GlobalData.prefs.setString('role', _role);
    _fromPage = widget.fromPage;
    if (_role == '小哥') {
      _businessList = ['专洗', '快洗'];
    } else if (_role == '店长') {
      _businessList = ['专洗'];
    } else if (_role == '司机') {
      _businessList = ['优洗'];
    }
    setState(() {
      isMulti = GlobalData.prefs.getBool('isMulti') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showBack: false,
        title: '',
        actionsWidget: IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              JumpReceive().jump(context, Routes.myPage);
            }),
      ),
      body: Container(
        color: Color(0xffF5F5F5),
        child: Column(
          children: <Widget>[
            Expanded(
              //列表
              child: Container(
                margin: EdgeInsets.fromLTRB(24, 13, 24, 30),
                child: _listViewBuilder(),
              ),
            ),
            !isMulti
                ? Container()
                : Expanded(
                    //列表
                    child: Container(
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '重新选择角色',
                          style:
                              TextStyle(color: Color(0xff4DB9FB), fontSize: 14),
                        )),
                  ))
          ],
        ),
      ),
    );
  }

  //列表控件
  Widget _listViewBuilder() {
    return Container(
      child: ListView.builder(
        itemCount: _businessList.length,
        itemBuilder: _listItemBuilder,
      ),
    );
  }

//列表 cell
  Widget _listItemBuilder(BuildContext context, int index) {
    String business = _businessList[index];
    return GestureDetector(
      onTap: () {
        print('你选择了$_role角色 和 $business 业务');
        if (business == '优洗') {
          JumpReceive().jump(context, Routes.transportLine);
        } else if (business == '专洗' && _role == '小哥') {
          //跳转
//          JumpReceive().jump(context, Routes.specialHomePage);
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => NavigatorIndex()),
                  (route) => route == null);
        } else {
          showToast('你当前没有权限访问该功能!');
        }
      },
      child: Container(
          // color: Colors.green,
          width: 328,
          height: 113,
          child: Image.asset(
            'images/' + business + '.png',
            fit: BoxFit.fill,
          )),
    );
  }
}
