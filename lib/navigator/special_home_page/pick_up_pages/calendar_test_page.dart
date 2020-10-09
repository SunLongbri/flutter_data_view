import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/day_count_model.dart';
import 'package:fluttermarketingplus/model/month_count_model.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'washing_detail_pages/calendar_info_widgets/bottom_info_widget.dart';
import 'washing_detail_pages/calendar_info_widgets/process_time_widget.dart';
import 'washing_detail_pages/calendar_info_widgets/task_info_widget.dart';

class CalendarTestPage extends StatefulWidget {
  CalendarTestPage({Key key, this.pickUpTask}) : super(key: key);

  final PickUpTask pickUpTask;

  @override
  _CalendarTestPageState createState() => _CalendarTestPageState();
}

class _CalendarTestPageState extends State<CalendarTestPage>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool _isMonthSelected; //周月视图控制器
  DataProvider _dataProvider;
  DateTime _selectedDay; //当前选择的时间
  DateTime _currentDay; //当前选择的时间
  DateTime _switchMonth; //切换的月份
  List<Time> _time; //一天数据详情
  bool _isLoading; //是否处于加载之中
  int _orderCount; //一天总订单数
  @override
  void initState() {
    super.initState();
    _orderCount = 0;
    _isLoading = false;
    _selectedDay = DateTime.now();
    _currentDay = DateTime.now();
    _switchMonth = DateTime.now();
    //初始化基本数据
    _initDayCountData();
    _initMonthCountData();
    _isMonthSelected = false;
    _events = {};

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  //初始化当天基本数据
  _initDayCountData() {
    var formData = {
      "orderType": "专洗",
      "currentTime":
          "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}"
    };
    setState(() {
      _isLoading = true;
    });
    postRequest(API.INIT_DAY_ORDER, formData, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      print('当天数据:${value}');
      DayCountModel _dayCountModel = DayCountModel.fromJson(value);
      _orderCount = _dayCountModel.data.goodsList.orderCount;
      List<String> _dayCount = [];
      for (int i = 0; i < _orderCount; i++) {
        _dayCount.add('count');
      }
      setState(() {
//        _events[_selectedDay] = _dayCount;
//        _events = {_selectedDay: _dayCount};
        _time = _dayCountModel.data.goodsList.time;
      });
    });
  }

  //初始化当月基本数据
  _initMonthCountData() {
    var monthFormData = {
      "orderType": "专洗",
      'currentTime': "${_switchMonth.year}-${_switchMonth.month}"
    };
    setState(() {
      _isLoading = true;
    });
    print('当月数据传参:${monthFormData.toString()}');
    postRequest(API.INIT_MONTH_ORDER, monthFormData,
            tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      print('当月数据:${value}');
      MonthCountModel _monthCountModel = MonthCountModel.fromJson(value);
      List<MonthDay> _monthDay = _monthCountModel.data.goodsList;

      List<String> washStr = [];
      Map<DateTime, List<String>> map = {};
      for (int i = 0; i < _monthDay.length; i++) {
        washStr = [];
        int orderCount = _monthDay[i].orderCount;
        int diff = _monthDay[i].dateDifferent;
        for (int j = 0; j < orderCount; j++) {
          washStr.add('wash');
        }
        map[_currentDay.add(Duration(days: diff))] = washStr;
      }
      print('当前的map集合:${map}');
      setState(() {
        _events = map;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: _calendarSwitchBarWidget(),
      body: LoadingContainer(
        isLoading: _isLoading,
        cover: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTableCalendarWithBuilders(),
              const SizedBox(height: 8.0),
              _isMonthSelected
                  ? Container()
                  : ProcessTimeWidget(
                      year: _selectedDay.year,
                      month: _selectedDay.month,
                      day: _selectedDay.day,
                      time: _time,
                    ),
              TaskInfoWidget()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomInfoWidget(
        pickUpTask: widget.pickUpTask,
      ),
    );
  }

  //标题栏组件
  Widget _calendarSwitchBarWidget() {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: ColorConstant.blueBgColor,
      leading: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          _dataProvider.isRefresh = true;
          _dataProvider.setUserSelectPosition = 0;
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'images/login_back.png',
            width: ScreenUtil().setWidth(21),
            height: AutoLayout.instance.pxToDp(33),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      title: _appBarTitleWidget(),
    );
  }

  //标题栏周月切换
  Widget _appBarTitleWidget() {
    return Container(
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(100)),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                _isMonthSelected = false;
                _calendarController.setCalendarFormat(CalendarFormat.week);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(136),
              height: AutoLayout.instance.pxToDp(48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100)),
              ),
              child: Text(
                '周',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(29),
                    color: _isMonthSelected
                        ? ColorConstant.greyTextColor
                        : ColorConstant.blueTextColor),
              ),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                _isMonthSelected = true;
                _calendarController.setCalendarFormat(CalendarFormat.month);
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(136),
              height: AutoLayout.instance.pxToDp(48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100)),
              ),
              child: Text(
                '月',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(29),
                    color: _isMonthSelected
                        ? ColorConstant.blueTextColor
                        : ColorConstant.greyTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'zh_CN',
      calendarController: _calendarController,
      events: _events,
      startDay: DateTime.now(),
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
          markersMaxAmount: 100),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          centerHeaderTitle: true,
          formatButtonVisible: false,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(100)),
          headerMargin: EdgeInsets.only(
              left: ScreenUtil().setWidth(26),
              right: ScreenUtil().setWidth(26),
              top: AutoLayout.instance.pxToDp(24),
              bottom: AutoLayout.instance.pxToDp(24)),
          headerPadding: EdgeInsets.all(0),
          titleTextStyle: TextStyle(
              color: ColorConstant.blueTextColor,
              fontSize: ScreenUtil().setSp(28))),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: ColorConstant.blueBgColor,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        //今天日期的背景
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: ColorConstant.blueBgLightColor,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            for (int k = 0; k < events.length; k++) {
              children.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarker(date, events),
                ),
              );
            }
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    int len = events.length;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: len > 30
            ? Color(0xffFA6060)
            : len > 10 ? Color(0xffF0B24C) : Color(0xff41CAAB),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDay = day;
      _calendarController.setCalendarFormat(CalendarFormat.week);
      _isMonthSelected = false;
    });
    _initDayCountData();
    _dataProvider.setUserSelectPosition = 0;
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    setState(() {
      _switchMonth = first;
    });
    _initMonthCountData();
    if (CalendarFormat.month == format) {
      setState(() {
        _isMonthSelected = true;
      });
    } else {
      setState(() {
        _isMonthSelected = false;
      });
    }
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }
}
