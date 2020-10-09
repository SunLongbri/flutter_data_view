import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/station_list_model.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/routers/routes.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import '../../../widgets/single_select_indicator_widget.dart';
import '../../../widgets/single_select_rectangle_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../widgets/single_pop_menu_widget.dart';

//网点业绩排名
class BrotherAchievementPage extends StatefulWidget {
  final String performance;

  BrotherAchievementPage({Key key, @required this.performance})
      : super(key: key);

  @override
  _BrotherAchievementPageState createState() => _BrotherAchievementPageState();
}

class _BrotherAchievementPageState extends State<BrotherAchievementPage> {
  int _sortColumnIndex;
  bool _sortAscending = true;
  List<String> _stationList = [];
  String _userSelect = '';
  String _type;
  String _time;
  String _sort;
  String _area;
  int _pageIndex;
  int _totalCount;
  bool _isLoading;

  //列表数据展示
  List<Station> _stationDataList;

  RefreshController _refreshController;

  @override
  void initState() {
    _isLoading = false;
    _totalCount = 0;
    super.initState();
    _pageIndex = 1;
    _stationDataList = [];
    _type = '1';
    _sort = '1';
    _time = '1';
    _area = '1';
    _refreshController = RefreshController(initialRefresh: false);
    _stationList = ['城市排名', '全国排名'];
    _userSelect = '城市排名';
    _refreshStationDataList();
  }

  //刷新网点业绩排名数据
  void _refreshStationDataList() {
    Map<String, String> params = {
      'type': _type,
      'time': _time,
      'sort': _sort,
      'area': _area,
      'pageindex': _pageIndex.toString(),
      'pagesize': '20'
    };
    setState(() {
      _isLoading = true;
    });
    getRequest(API.DOT_STATION_DATA_LIST, queryParameters: params).then((val) {
      setState(() {
        _isLoading = false;
      });
      print('网点业绩排名接受到的数据:${val}');
      StationListModel stationListModel = StationListModel.fromJson(val);
      if (stationListModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (stationListModel.status == GlobalData.REQUEST_SUCCESS) {
        //数据返回成功
        setState(() {
          if (_pageIndex == 1) {
            _stationDataList.clear();
            _stationDataList.add(stationListModel.data.station);
          }
          _stationDataList.addAll(stationListModel.data.page.list);
          _totalCount = int.parse(stationListModel.data.page.total);
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
        title: '网点业绩排名',
      ),
      body: LoadingContainer(
        cover: true,
        isLoading: _isLoading,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
          itemCount: _stationDataList.length,
          itemBuilder: (BuildContext context, int position) {
            return _singleLineDataWidget(
                position,
                _stationDataList[position].name,
                _stationDataList[position].count.toString(),
                _stationDataList[position].price.toString().split('.')[0],
                _stationDataList[position].commission.toString().split('.')[0],
                _stationDataList[position].num.toString().contains('.')
                    ? _stationDataList[position].num.toString().split('.')[0]
                    : _stationDataList[position].num.toString());
          }),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 500),
      ),
      header: WaterDropHeader(),
      onLoading: () async {
        _pageIndex++;
        _refreshStationDataList();
      },
    ));
  }

  //单行数据列表组件
  Widget _singleLineDataWidget(int position, String stationName, String count,
      String realPrice, String commissionPrice, String stationNum) {
    Color bgColor = Colors.white;
    Color textColor = ColorConstant.greyTextColor;
    if (position == 0) {
      textColor = ColorConstant.blueTextColor;
//      textColor = Colors.white;
    }
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: position == 0
          ? () {
              //跳转到小哥业绩排名页面
              JumpReceive().jump(context, Routes.deliverAchievementPage);
            }
          : null,
      child: Container(
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
          _textWidget('网点', 1),
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
//        _stationDataList.clear();
        setState(() {
          _pageIndex = 1;
          _sortTextController = content;
          if (content.compareTo('单量') == 0) {
            _sort = '1';
          } else if (content.compareTo('实收') == 0) {
            _sort = '2';
          } else if (content.compareTo('提成') == 0) {
            _sort = '3';
          }
        });
        _refreshStationDataList();
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
            _stationDataList.clear();
            _userSelect = value;
            if (value.compareTo('城市排名') == 0) {
              _area = '1';
            } else if (value.compareTo('全国排名') == 0) {
              _area = '2';
            } else if (value.compareTo('门店排名') == 0) {
              _area = '3';
            }
          });
          _refreshStationDataList();
        },
      ),
    );
  }

  //鲜花还是洗涤类型选择
  Widget _typeSelectWidget() {
    return SingleSelectRectangleWidget(
      listContent: ['鲜花', '洗涤'],
      stringBlock: (firstSelectContent) {
        setState(() {
          _pageIndex = 1;
          _stationDataList.clear();
          if (firstSelectContent.compareTo('鲜花') == 0) {
            _type = '1';
          } else if (firstSelectContent.compareTo('洗涤') == 0) {
            _type = '2';
          }
        });
        _refreshStationDataList();
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
          _stationDataList.clear();
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
        _refreshStationDataList();
      },
    );
  }
}
