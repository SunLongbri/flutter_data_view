import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttermarketingplus/model/goods_list_model.dart';
import 'package:fluttermarketingplus/model/order_detail_model.dart';
import 'package:fluttermarketingplus/model/pickup_model.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';

class DataProvider with ChangeNotifier {
//  Locale("zh", "");
//  Locale("en", "");
  Locale _locale = Locale("zh", ""); //国际化语言设置
  double _taskRate = 0;
  double _dotRate = 0;
  bool _isRefresh = false; //是否自动刷新
  bool _goodsRefresh = false; //商品品类页面刷新控制器
  bool _isRefreshTab = false; //商品左侧菜单刷新
  String _sacnCode; //扫描后的条码
  AmapController _amapController = null; //地图控制器
  List<Marker> _amapMarkers = []; //地图标记
  SpecialWashingModel _specialWashingModel = null;
  List<SingleGoods> _goodsList = []; //商品品类数据
  Map<String, List<SingleGoods>> _tempGoodsMap = Map();
  Map<String, int> _tempCountMap = Map(); //商品混存数量
  List<PickUpTask> _pickUpTaskList = null;
  String _userSelectTab = '上衣';
  String _secondChildKeyStr = ''; //第二级子节点id编号
  String _thirdChildKeyStr = ''; //第三级子节点id编号
  double _totalPrice = .0; //商品价格总和
  String _currentBindOrderId = ''; //当前绑定衣物的订单号
  bool _partSignFor = false; //部分签收衣物的状态
  List<String> _partsGoodsList = []; //部分签收衣物的标签数组
  List<GoodsList> _confirmGoodsList = []; //部分签收衣物的标签数组
  String _orderCode = ''; //用户输入的券码
  String _selectTime = ''; //小哥在日历页面预约的时间
  String _orderPayState = ''; //订单支付状态
  String _orderState = '';//首页-全部订单-当前订单状态
  int _userSelectPosition = 0; //日历页面，时刻选择

  Map get getTempGoodsMap => _tempGoodsMap;

  int get getUserSelectPosition => _userSelectPosition;

  String get getOrderPayState => _orderPayState;

  String get getOrderState => _orderState;

  String get getSelectTime => _selectTime;

  List<GoodsList> get getConfirmGoodsList => _confirmGoodsList;

  List<String> get getPartsGoodsList => _partsGoodsList;

  Map get getTempCountMap => _tempCountMap;

  double get getTotalPrice => _totalPrice;

  bool get getPartSignForState => _partSignFor;

  String get getOrderCode => _orderCode;

  String get getSecondChildKey => _secondChildKeyStr;

  String get getThirdChildKey => _thirdChildKeyStr;

  Locale get isLocal => _locale;

  bool get getGoodsRefresh => _goodsRefresh;

  bool get getRefreshTab => _isRefreshTab;

  String get getUserSelectTab => _userSelectTab;

  double get taskRate => _taskRate;

  double get dotRate => _dotRate;

  bool get isRefresh => _isRefresh;

  String get sacnCode => _sacnCode;

  String get getCurrentBindOrderId => _currentBindOrderId;

  AmapController get getAmapController => _amapController;

  List<Marker> get getAmapMarkers => _amapMarkers;

  SpecialWashingModel get getSpecialWashingModel => _specialWashingModel;

  List<PickUpTask> get getPickUpTaskList => _pickUpTaskList;

  List<SingleGoods> get getGoodsList => _goodsList;

  set setUserSelectPosition(int position) {
    _userSelectPosition = position;
    notifyListeners();
  }

  set setOrderState(String orderState){
    _orderState = orderState;
    notifyListeners();
  }

  set setOrderPayState(String payState) {
    _orderPayState = payState;
    notifyListeners();
  }

  set setOrderCode(String orderCode) {
    _orderCode = orderCode;
    notifyListeners();
  }

  set setSelectTime(String selectTime) {
    _selectTime = selectTime;
    notifyListeners();
  }

  set setPartSignForState(bool signForState) {
    _partSignFor = signForState;
    notifyListeners();
  }

  set setPartsGoodsList(List<String> partsGoods) {
    _partsGoodsList = partsGoods;
    notifyListeners();
  }

  set setConfirmGoodsList(List<GoodsList> confirmGoodsList) {
    _confirmGoodsList = confirmGoodsList;
    notifyListeners();
  }

  set setTempGoodsMap(Map<String, List<SingleGoods>> tempGoodsMap) {
    _tempGoodsMap = tempGoodsMap;
    notifyListeners();
  }

  set setCurrentBindOrderId(String bindOrderId) {
    _currentBindOrderId = bindOrderId;
    notifyListeners();
  }

  set setTotalPrice(double price) {
    _totalPrice = price;
    notifyListeners();
  }

  set setTempCountMap(Map<String, int> tempCountMap) {
    _tempCountMap = tempCountMap;
    notifyListeners();
  }

  set setSecondChildKey(String tempChildKey) {
    _secondChildKeyStr = tempChildKey;
    notifyListeners();
  }

  set setThirdChildKey(String tempChildKey) {
    _thirdChildKeyStr = tempChildKey;
    notifyListeners();
  }

  set setGoodsRefresh(bool goodsRefresh) {
    _goodsRefresh = goodsRefresh;
    notifyListeners();
  }

  set setRefreshTab(bool refreshTab) {
    _isRefreshTab = refreshTab;
    notifyListeners();
  }

  set setGoodsList(List<SingleGoods> goodsList) {
    _goodsList = goodsList;
    notifyListeners();
  }

  set setUserSelectTab(String userSelectTab) {
    _userSelectTab = userSelectTab;
    notifyListeners();
  }

  set isRefresh(bool refresh) {
    _isRefresh = refresh;
    notifyListeners();
  }

  set setPickUpTaskList(List<PickUpTask> pickUpTaskList) {
    _pickUpTaskList = pickUpTaskList;
    notifyListeners();
  }

  set locale(Locale isLocal) {
    _locale = isLocal;
    notifyListeners();
  }

  set dotRate(double dotRate) {
    _dotRate = dotRate;
    notifyListeners();
  }

  set taskRate(double rate) {
    _taskRate = rate;
    notifyListeners();
  }

  set sacnCode(String code) {
    _sacnCode = code;
    notifyListeners();
  }

  set setAmapController(AmapController amapController) {
    _amapController = amapController;
    notifyListeners();
  }

  set setAmapMarkers(List<Marker> markers) {
    _amapMarkers = markers;
    notifyListeners();
  }

  set setSpecialWashingModel(SpecialWashingModel specialWashingModel) {
    _specialWashingModel = specialWashingModel;
    notifyListeners();
  }
}
