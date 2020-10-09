import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'search_address_widgets/address_bar_widget.dart';
//import 'package:amap_search_fluttify/amap_search_fluttify.dart';

//搜索地址页面
class SearchAddressPage extends StatefulWidget {
  @override
  _SearchAddressPageState createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage>
   {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            AddressBarWidget(
              onTap: () async {
//                final poiList = await AmapSearch.searchKeyword(
//                  '小区',
//                  city: '上海',
//                );
//                List<String> _poiTitleList =
//                    poiList.map((it) => it.toString()).toList();
//                for (int i = 0; i < _poiTitleList.length; i++) {
//                  print("小区名称:${_poiTitleList[i]}");
//                }
              },
            ),
            Expanded(
                child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int position) {
                          return _singleAddressLocationWidget();
                        })))
          ],
        ),
      ),
    );
  }

  Widget _singleAddressLocationWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            width: 0.5,
            color: Color(0xff979797),
          ))),
      height: AutoLayout.instance.pxToDp(138),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                right: ScreenUtil().setWidth(20)),
            width: ScreenUtil().setWidth(30),
            child: Image.asset('images/address_location_icon.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '上海科技企业孵化协会上海市众创空间',
                style: TextStyle(
                    color: ColorConstant.blackTextColor,
                    fontSize: ScreenUtil().setSp(32)),
              ),
              Text(
                '上海科技企业孵化协会上海市众创空间',
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(28)),
              )
            ],
          )
        ],
      ),
    );
  }
}
