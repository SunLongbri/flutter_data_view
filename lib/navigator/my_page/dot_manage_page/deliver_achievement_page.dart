import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/deliver_list_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:fluttermarketingplus/widgets/single_pop_menu_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_indicator_widget.dart';
import 'package:fluttermarketingplus/widgets/single_select_rectangle_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//小哥业绩排名
class DeliverAchievementPage extends StatefulWidget {
  @override
  _DeliverAchievementPageState createState() => _DeliverAchievementPageState();
}

class _DeliverAchievementPageState extends State<DeliverAchievementPage> {
  int _pageIndex;
  int _totalCount;
  RefreshController _refreshController;
  bool _isLoading;
  String _type;
  String _time;
  String _sort;
  String _area;

  //网点小哥数量分割线
  int _deliverIndex;

  //数据列表
  List<Deliver> _listData;

  @override
  void initState() {
    super.initState();
    _deliverIndex = 0;
    _stationList = ['门店排名', '城市排名', '全国排名'];
    _userSelect = '门店排名';
    _isLoading = false;
    _totalCount = 0;
    _pageIndex = 1;
    _refreshController = RefreshController(initialRefresh: false);
    _type = '1';
    _sort = '1';
    _time = '1';
    _area = '3';
    _listData = [];
    _refreshAchievementData();
  }

  void _onLoading() async {
    print('_totalCount:${_totalCount},_pageIndex:${_pageIndex}');
    _pageIndex++;
    _refreshAchievementData();
  }

  //刷新小哥业绩数据
  _refreshAchievementData() {
    setState(() {
      _isLoading = true;
    });
    Map<String, String> params = {
      'type': _type,
      'time': _time,
      'area': _area,
      'sort': _sort,
      'pageindex': _pageIndex.toString(),
      'pagesize': '20'
    };
    getRequest(API.DELIVER_ACHIEVE_RANKING, queryParameters: params)
        .then((val) {
      print('小哥业绩排行:${val}');
      setState(() {
        _isLoading = false;
      });
      DeliverListModel deliverAchievementModel = DeliverListModel.fromJson(val);
      if (deliverAchievementModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (deliverAchievementModel.status == GlobalData.REQUEST_SUCCESS) {
        setState(() {
          _deliverIndex = deliverAchievementModel.data.station.length;
          if (_pageIndex == 1) {
            _listData.clear();
            _listData.addAll(deliverAchievementModel.data.station);
          }
          _listData.addAll(deliverAchievementModel.data.page.list);
          _totalCount = int.parse(deliverAchievementModel.data.page.total);
        });
      } else {
        showToast('网络开小车了,请稍后再试!');
      }

      if (_totalCount < (_pageIndex * 20)) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '小哥业绩排名',
      ),
      body: LoadingContainer(
        isLoading: _isLoading,
        cover: true,
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _typeSelectWidget(),
              _timeSelectWidget(),
              _space(),
              _titleWidget(),
              _showDataListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  //数据展示列表组件
  Widget _showDataListWidget() {
    return Expanded(
        child: SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      child: ListView.builder(
          itemCount: _listData.length,
          itemBuilder: (BuildContext context, int position) {
            return _singleLineDataWidget(
                position,
                _listData[position].name,
                _listData[position].count.toString(),
                _listData[position].price.toString().split('.')[0],
                _listData[position].commission.toString().split('.')[0],
                _listData[position].num.toString().contains('.')
                    ? _listData[position].num.toString().split('.')[0]
                    : _listData[position].num.toString());
          }),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 500),
      ),
      header: WaterDropHeader(),
      onLoading: _onLoading,
    ));
  }

  //单行数据列表组件
  Widget _singleLineDataWidget(int position, String stationName, String count,
      String realPrice, String commissionPrice, String stationNum) {
    Color bgColor = Colors.white;
    Color textColor = ColorConstant.greyTextColor;
    if (position < _deliverIndex) {
      textColor = ColorConstant.blueTextColor;
//      textColor = Colors.white;
    }
    return Container(
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
      color: bgColor,
      height: AutoLayout.instance.pxToDp(78),
      child: Row(
        children: <Widget>[
          _cellDataWidget(stationName, textColor),
          _cellDataWidget(count, textColor),
          _cellDataWidget('¥${realPrice}', textColor),
          _cellDataWidget('¥${commissionPrice}', textColor),
          _cellDataWidget('排名第${stationNum}', textColor),
        ],
      ),
    );
  }

  //单行数据组件
  Widget _cellDataWidget(String contentData, Color textColor) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
      child: Text(
        contentData,
        style: TextStyle(color: textColor, fontSize: ScreenUtil().setSp(25)),
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget _space() {
    return Container(
      height: AutoLayout.instance.pxToDp(24),
      color: ColorConstant.greyBgColor,
    );
  }

  //标题栏组件
  Widget _titleWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(77),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        children: <Widget>[
          _textWidget('姓名', 1),
          _sortTextWidget(_sortContent),
          _rankSelectWidget()
        ],
      ),
    );
  }

  Widget _textWidget(String content, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          content,
          style: TextStyle(
              color: ColorConstant.blackTextColor,
              fontSize: ScreenUtil().setSp(25)),
        ),
      ),
    );
  }

  List<String> _sortContent = ['单量', '实收', '提成'];
  String _sortTextController = '单量';

  //单量，实收文字类型排序组件
  Widget _sortTextWidget(List<String> sortContent) {
    List<Widget> sortTextWidget = [];
    for (int i = 0; i < sortContent.length; i++) {
      sortTextWidget.add(_singleTextTapWidget(sortContent[i]));
    }
    return Expanded(
      flex: 3,
      child: Row(
        children: sortTextWidget,
      ),
    );
  }

  Widget _singleTextTapWidget(String content) {
    Color _textColor = ColorConstant.blackTextColor;
    String _arrowImgAssets = 'images/arrow_down_black.png';
    if (_sortTextController.compareTo(content) == 0) {
      _textColor = ColorConstant.blueTextColor;
      _arrowImgAssets = 'images/arrow_down_blue.png';
    }
    return Expanded(
        child: InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
//        _listData.clear();
        setState(() {
          _sortTextController = content;
          if (content.compareTo('单量') == 0) {
            _sort = '1';
          } else if (content.compareTo('实收') == 0) {
            _sort = '2';
          } else if (content.compareTo('提成') == 0) {
            _sort = '3';
          }
        });
        _refreshAchievementData();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              content,
              style: TextStyle(
                  color: _textColor, fontSize: ScreenUtil().setSp(25)),
            ),
            Image.asset(
              _arrowImgAssets,
              height: AutoLayout.instance.pxToDp(28),
              fit: BoxFit.fitHeight,
            )
          ],
        ),
      ),
    ));
  }

  //鲜花还是洗涤类型选择
  Widget _typeSelectWidget() {
    return SingleSelectRectangleWidget(
      listContent: ['鲜花', '洗涤'],
      stringBlock: (firstSelectContent) {
        setState(() {
          _pageIndex = 1;
          _listData.clear();
          if (firstSelectContent.compareTo('鲜花') == 0) {
            _type = '1';
          } else if (firstSelectContent.compareTo('洗涤') == 0) {
            _type = '2';
          }
        });
        _refreshAchievementData();
      },
    );
  }

  //昨日，上周时间选择
  Widget _timeSelectWidget() {
    return SingleSelectIndicatorWidget(
      listContent: ['昨日', '上周', '上月', '上季度'],
      paddingBottom: 1,
      stringBlock: (secondSelectContent) {
        setState(() {
          _pageIndex = 1;
          _listData.clear();
          if (secondSelectContent.compareTo('昨日') == 0) {
            _time = '1';
          } else if (secondSelectContent.compareTo('上周') == 0) {
            _time = '2';
          } else if (secondSelectContent.compareTo('上月') == 0) {
            _time = '3';
          } else if (secondSelectContent.compareTo('上季度') == 0) {
            _time = '4';
          }
        });
        _refreshAchievementData();
      },
    );
  }

  String _userSelect = '';
  List<String> _stationList = [];

  //全国排名类型选择
  Widget _rankSelectWidget() {
    return Container(
      child: SinglePopMenuWidget(
        head: _userSelect,
        options: _stationList,
        onSelected: (String value) async {
          _refreshController.loadComplete();
          setState(() {
            _pageIndex = 1;
            _listData.clear();
            _userSelect = value;
            if (value.compareTo('城市排名') == 0) {
              _area = '1';
            } else if (value.compareTo('全国排名') == 0) {
              _area = '2';
            } else if (value.compareTo('门店排名') == 0) {
              _area = '3';
            }
          });
          _refreshAchievementData();
        },
      ),
    );
  }
}
