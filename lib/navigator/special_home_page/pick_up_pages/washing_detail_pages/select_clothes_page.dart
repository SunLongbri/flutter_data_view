import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/wash_type_child_model.dart';
import 'package:fluttermarketingplus/model/wash_type_name_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'select_clothes_class.dart';
import 'select_clothes_widgets/bottom_info_widget.dart';
import 'select_clothes_widgets/left_tab_widget.dart';
import 'select_clothes_widgets/right_goods_widget.dart';

//小哥选择衣物页面
class SelectClothesPage extends StatefulWidget {
  final String cityName;
  final String orderId;

  const SelectClothesPage({Key key, this.cityName, this.orderId})
      : super(key: key);

  @override
  _SelectClothesPageState createState() => _SelectClothesPageState();
}

class _SelectClothesPageState extends State<SelectClothesPage>
    with GetTypeData {
  DataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: '选择商品品类',
        backPress: () {
          _dataProvider.setGoodsList = [];
          _dataProvider.setUserSelectTab = '上衣';
          _dataProvider.setTotalPrice = .0;
          _dataProvider.setTempCountMap = Map();
          _dataProvider.setConfirmGoodsList = [];
          _dataProvider.isRefresh = true;
          Navigator.pop(context);
        },
      ),
      body: LoadingContainer(
        isLoading: _dataProvider.getGoodsRefresh,
        cover: true,
        child: Row(
          children: <Widget>[
            LeftTabWidget(
              cityName: widget.cityName,
            ),
            Expanded(
                child: RightGoodsWidget(
              orderId: widget.orderId,
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomInfoWidget(),
    );
  }
}
