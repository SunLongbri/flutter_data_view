import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/model/pickup_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:provider/provider.dart';

import 'special_home_page_widgets/control_panel_widget.dart';
import 'special_home_page_widgets/home_amap_widget.dart';
import 'special_home_page_widgets/search_widget.dart';

//专洗首页面
class SpecialHomePage extends StatefulWidget {
  @override
  _SpecialHomePageState createState() => _SpecialHomePageState();
}

class _SpecialHomePageState extends State<SpecialHomePage> {
  SpecialWashingModel specialWashingModel;
  DataProvider _dataProvider;

  @override
  void initState() {
    getRequest(API.SPECIAL_WASHING_PICKUP, tempBaseUrl: API.TEST_BASE_URL)
        .then((val) {
      print('专洗地图首页：val ----> ${val}');
      setState(() {
        specialWashingModel = SpecialWashingModel.fromJson(val);
        Future.delayed(Duration(milliseconds: 1000)).then((e) {
          _dataProvider.setSpecialWashingModel = specialWashingModel;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            //首页地图
            HomeAmapWidget(),
            //顶部搜索bar
            SearchBarWidget(),
            Align(
              alignment: FractionalOffset(0, 1),
              //底部控制面板
              child: ControlPanelWidget(),
            )
          ],
        ),
      ),
    );
  }
}
