import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/exit_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_page/my_page.dart';
import 'special_home_page/special_home_page.dart';

//底部菜单引导
class NavigatorIndex extends StatefulWidget {
  @override
  _NavigatorIndexState createState() => _NavigatorIndexState();
}

class _NavigatorIndexState extends State<NavigatorIndex> {
  SharedPreferences prefs;

  //1.定义一个集合来盛放四个页面
  final List<Widget> tabBodies = [
    SpecialHomePage(),
    MyPage(),
  ];
  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    // 默认页面
    currentPage = tabBodies[currentIndex];
    initData();
    super.initState();
  }

  //初始化本地存储，如果有登陆页，防置到登陆页
  Future initData() async {
    prefs = await SharedPreferences.getInstance();
    GlobalData.prefs = prefs;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: tabBodies,
          ),
          bottomNavigationBar: CupertinoTabBar(
            currentIndex: currentIndex,
            onTap: (i) {
              this.changeIndex(i);
            },
            items: [
              _bottomBarItem('业务', 'navigator_home_select.png',
                  'navigator_home_unselect.png'),
//              _bottomBarItem(
//                  '订单',
//                  'navigator_learning_select.png',
//                  'navigator_learning_unselect.png'),
              _bottomBarItem(
                  '我的', 'navigator_me_select.png', 'navigator_me_unselect.png'),
            ],
          ),
        ),
        onWillPop: exitApp);
  }

  //底部单个BarItem
  BottomNavigationBarItem _bottomBarItem(
      String title, String selectImg, String unselectImg) {
    return BottomNavigationBarItem(
      activeIcon: Image.asset(
        'images/${selectImg}',
//        width: AutoLayout.instance.pxToDp(48),
        height: AutoLayout.instance.pxToDp(48),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: ScreenUtil().setSp(20)),
      ),
      icon: Image.asset(
        'images/${unselectImg}',
//        width: AutoLayout.instance.pxToDp(48),
        height: AutoLayout.instance.pxToDp(48),
      ),
    );
  }

  changeIndex(int _index) {
    setState(() {
      //更换索引
      currentIndex = _index;
      //根据索引来找到是哪个页面
      currentPage = tabBodies[currentIndex];
    });
  }
}
