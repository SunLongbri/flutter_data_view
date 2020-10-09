import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/goods_list_model.dart';
import 'package:fluttermarketingplus/model/wash_type_child_model.dart';
import 'package:fluttermarketingplus/model/wash_type_name_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:provider/provider.dart';

//左侧tab切换组件
class LeftTabWidget extends StatefulWidget {
  final String cityName;

  const LeftTabWidget({Key key, this.cityName}) : super(key: key);

  @override
  _LeftTabWidgetState createState() => _LeftTabWidgetState();
}

class _LeftTabWidgetState extends State<LeftTabWidget> {
  String _cityName;
  List<Widget> _leftWidgets;
  DataProvider _dataProvider;
  List<TypeList> _typeList = [];
  List<List<GoodsList>> _tempList = [];

  //缓存商品列表信息
  Map<String, List<SingleGoods>> tempGoodsMap;

  //初始化商品列表数据用
  String _firstChildName;
  String _secondChildID;

  @override
  void initState() {
    _firstChildName = '';
    _secondChildID = '';
    _leftWidgets = [];
    _cityName = widget.cityName ?? '';
    tempGoodsMap = Map();
    _refreshTab();
    super.initState();
  }

  _refreshTab() async {
    _leftWidgets.clear();
    var formData = {"cityName": _cityName};
    if (_dataProvider != null) {
      _dataProvider.setGoodsRefresh = true;
    }
    if (_typeList.isEmpty || _tempList.isEmpty) {
      await postRequest(API.EXCELLENT_TYPE_NAME, formData).then((value) async {
        WashTypeNameModel _washTypeNameModel =
            WashTypeNameModel.fromJson(value);
        if (_washTypeNameModel.code == 200) {
          _typeList = _washTypeNameModel.data.typeList;
          for (int i = 0; i < _typeList.length; i++) {
            String typeName = _typeList[i].type;
            print('第一级节点的名字为:${typeName}');
            if (i == 0) {
              _firstChildName = typeName;
            }
            if (typeName == '洗衣') {
              _leftWidgets.add(
                  _singleKindWidget(typeName, 'images/kinds_jacket_icon.png'));
            } else if (typeName == '洗鞋') {
              _leftWidgets.add(
                  _singleKindWidget(typeName, 'images/kinds_shoes_icon.png'));
            } else if (typeName == '洗包') {
              _leftWidgets.add(
                  _singleKindWidget(typeName, 'images/kinds_package_icon.png'));
            } else if (typeName == '洗奢侈品') {
              _leftWidgets.add(
                  _singleKindWidget(typeName, 'images/kinds_luxury_icon.png'));
            } else if (typeName == '洗居家品') {
              _leftWidgets.add(
                  _singleKindWidget(typeName, 'images/kinds_home_icon.png'));
            } else {
              _leftWidgets.add(
                  _singleKindWidget(typeName, 'images/kinds_jacket_icon.png'));
            }

            var formData = {"type": typeName, "cityName": _cityName};
            await postRequest(API.EXCELLENT_WASH_TYPE_CHILD, formData)
                .then((value) {
              if (_dataProvider != null) {
                _dataProvider.setGoodsRefresh = false;
              }
              WashTypeChildModel washTypeChildModel =
                  WashTypeChildModel.fromJson(value);
              if (washTypeChildModel.code == 200) {
                List<GoodsList> _singleGoods =
                    washTypeChildModel.data.goodsList;
                _tempList.add(_singleGoods);
                for (int j = 0; j < _singleGoods.length; j++) {
                  if (i == 0 && j == 0) {
                    _secondChildID = _singleGoods[j].childTypeId;
                    _dataProvider.setSecondChildKey = _secondChildID;
                  }
                  print(
                      '第二级子节点的名字:${_singleGoods[j].childTypeName},id号为:${_singleGoods[j].childTypeId}');
                  _leftWidgets.add(_singleTabWidget(
                      typeName,
                      _singleGoods[j].childTypeName,
                      _singleGoods[j].childTypeId,
                      '0'));
                }
              }
            });
          }
        }
      });
      _refreshGoods(_firstChildName, _secondChildID);
    } else {
      for (int i = 0; i < _typeList.length; i++) {
        String typeName = _typeList[i].type;
        print('缓存数据 ---->  第一级节点的名字为:${typeName}');
        if (typeName == '洗衣') {
          _leftWidgets
              .add(_singleKindWidget(typeName, 'images/kinds_jacket_icon.png'));
        } else if (typeName == '洗鞋') {
          _leftWidgets
              .add(_singleKindWidget(typeName, 'images/kinds_shoes_icon.png'));
        } else if (typeName == '洗包') {
          _leftWidgets.add(
              _singleKindWidget(typeName, 'images/kinds_package_icon.png'));
        } else if (typeName == '洗奢侈品') {
          _leftWidgets
              .add(_singleKindWidget(typeName, 'images/kinds_luxury_icon.png'));
        } else if (typeName == '洗居家品') {
          _leftWidgets
              .add(_singleKindWidget(typeName, 'images/kinds_home_icon.png'));
        } else {
          _leftWidgets
              .add(_singleKindWidget(typeName, 'images/kinds_jacket_icon.png'));
        }
        List<GoodsList> _singleGoods = _tempList[i];
        int goodsCount = 0;
        for (int j = 0; j < _singleGoods.length; j++) {
          String childTypeId = _singleGoods[j].childTypeId;
          print(
              '缓存数据 ---->  第二级子节点的名字:${_singleGoods[j].childTypeName},id号为:${childTypeId}');
          Map<String, int> _tempCountMap = _dataProvider.getTempCountMap;
          if (_tempCountMap.containsKey(childTypeId)) {
            goodsCount = _tempCountMap[childTypeId];
          } else {
            goodsCount = 0;
          }
          setState(() {
            _leftWidgets.add(_singleTabWidget(
                typeName,
                _singleGoods[j].childTypeName,
                childTypeId,
                goodsCount.toString().trim()));
          });
        }
      }
      if (_dataProvider != null) {
        _dataProvider.setGoodsRefresh = false;
      }
    }
  }

  _refreshGoods(String typeName, String typeId) {
    print('当前的tempGoodsMap:${tempGoodsMap}');
    _dataProvider.setGoodsRefresh = true;
    if (tempGoodsMap.containsKey(typeId)) {
      _dataProvider.setGoodsList = tempGoodsMap[typeId];
      _dataProvider.setGoodsRefresh = false;
      return;
    }
    var formData = {
      "type": "优洗",
      "goodsType": typeName,
      "childTypeId": typeId,
      "cityName": _cityName
    };
    postRequest(API.GOODS_LIST_INFO, formData).then((value) {
      _dataProvider.setGoodsRefresh = false;
      GoodsListModel goodsListModel = GoodsListModel.fromJson(value);
      if (goodsListModel.code == 200) {
        List<SingleGoods> _goodsList = goodsListModel.data.goodsList;
        tempGoodsMap[typeId] = _goodsList;
        _dataProvider.setTempGoodsMap = tempGoodsMap;
        _dataProvider.setGoodsList = _goodsList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    if (_dataProvider.getRefreshTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dataProvider.getTotalPrice > 0) {
          _dataProvider.setRefreshTab = false;
          _refreshTab();
        }
      });
    }

    return Container(
      width: ScreenUtil().setWidth(220),
      child: ListView.builder(
          itemCount: _leftWidgets.length,
          itemBuilder: (BuildContext context, int position) {
            return _leftWidgets[position];
          }),
    );
  }

  Widget _singleTabWidget(
      String typeName, String content, String typeId, String goodsCount) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        _dataProvider.setUserSelectTab = content;
        _dataProvider.setSecondChildKey = typeId;

        _refreshTab();
        _refreshGoods(typeName, typeId);
      },
      child: Container(
        height: AutoLayout.instance.pxToDp(100),
        decoration: BoxDecoration(
            color: _dataProvider.getUserSelectTab == content
                ? Colors.white
                : Color(0xffF8F8F8),
            border: _dataProvider.getUserSelectTab == content
                ? Border(
                    left:
                        BorderSide(color: ColorConstant.blueBgColor, width: 3))
                : null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
              child: Text(
                content,
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(30)),
              ),
            ),
            goodsCount == '0'
                ? Container()
                : Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(5),
                        right: ScreenUtil().setWidth(5)),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      goodsCount,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(25)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  //单个品类组件
  Widget _singleKindWidget(String content, String imgAssets) {
    return Container(
      color: Color(0xffE4EEFC),
      height: AutoLayout.instance.pxToDp(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(38),
            child: Image.asset(imgAssets),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Text(
              content,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(36)),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    tempGoodsMap.clear();
    _typeList.clear();
    _tempList.clear();
    super.dispose();
  }
}
