import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/pickup_route_model.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';

import 'calendar_info_widgets/bottom_info_widget.dart';
import 'calendar_info_widgets/custom_style_weekbar_item.dart';
import 'calendar_info_widgets/process_time_widget.dart';
import 'calendar_info_widgets/task_info_widget.dart';

//受理订单，日历页面
class CalendarInfoPage extends StatefulWidget {
  final PickUpTask pickUpTask;

  const CalendarInfoPage({Key key, this.pickUpTask}) : super(key: key);

  @override
  _CalendarInfoPageState createState() => _CalendarInfoPageState();
}

class _CalendarInfoPageState extends State<CalendarInfoPage> {
  CalendarController controller;
  CalendarViewWidget calendar;
  HashSet<DateTime> _selectedDate = HashSet();
  HashSet<DateModel> _selectedModels = HashSet();
  bool _isMonthSelected = false;
  String _selectDate = '';
  DateModel _userSelectDataModel;

  GlobalKey<CalendarContainerState> _globalKey = new GlobalKey();

  var dataTime; //当前时间
  @override
  void initState() {
    dataTime = DateTime.now();
    int month = dataTime.month;
    int year = dataTime.year;
    int day = dataTime.day;
    _userSelectDataModel = DateModel();
    _userSelectDataModel.year = year;
    _userSelectDataModel.month = month;
    _userSelectDataModel.day = day;
    _userSelectDataModel.isSelected = true;
    _initCalendarData();
    super.initState();
  }

  _initCalendarData() {
    _selectedDate.add(dataTime);
    controller = CalendarController(
        offset: 1,
        minYear: dataTime.year,
        minYearMonth: dataTime.month,
        minSelectYear: dataTime.year,
        minSelectMonth: dataTime.month,
        minSelectDay: dataTime.day - 1,
        maxYear: dataTime.year + 1,
        maxYearMonth: dataTime.month + 1,
        showMode: CalendarConstants.MODE_SHOW_WEEK_AND_MONTH,
        selectedDateTimeList: _selectedDate,
        selectDateModel: _userSelectDataModel,
        selectMode: CalendarSelectedMode.singleSelect)
      //点击选择事件
      ..addOnCalendarSelectListener((dateModel) {
        _selectedModels.clear();
        _selectedModels.add(dateModel);
        setState(() {
          _selectDate = _selectedModels.toString();
          _userSelectDataModel = dateModel;
        });
      })
      //月份切换事件
      ..addMonthChangeListener((year, month) {
        setState(() {
          _userSelectDataModel.year = year;
          _userSelectDataModel.month = month;
        });
      });
    calendar = new CalendarViewWidget(
      weekBarItemWidgetBuilder: () {
        return CustomStyleWeekBarItem();
      },
      key: _globalKey,
      calendarController: controller,
      dayWidgetBuilder: (DateModel model) {
        double wd = (MediaQuery.of(context).size.width - 20) / 7;
        bool _isSelected = model.isSelected;
        if (_isSelected &&
            CalendarSelectedMode.singleSelect ==
                controller.calendarConfiguration.selectMode) {
          _selectDate = model.toString();
          _userSelectDataModel = model;
        }
        return Container(
          height: AutoLayout.instance.pxToDp(140),
          margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(8),
            left: ScreenUtil().setWidth(8),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color:
                  _isSelected ? ColorConstant.blueBgLightColor : Colors.white,
              borderRadius: BorderRadius.circular(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                model.day.toString(),
                style: TextStyle(
                    color: model.isCurrentMonth
                        ? (_isSelected == false
                            ? (model.isWeekend
                                ? Colors.black38
                                : ColorConstant.blackTextColor)
                            : ColorConstant.blueTextColor)
                        : Colors.black38),
              ),
              Text(
                '${model.lunarDay.toString()}个',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: model.lunarDay > 10
                        ? Color(0xffF0B24C)
                        : model.lunarDay > 30
                            ? Color(0xffFA6060)
                            : Color(0xff46CDAF)),
              ),
            ],
          ),
        );
      },
    );
    //监听日历的展开收缩状态
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addExpandChangeListener((value) {
        setState(() {
          _isMonthSelected = value;
        });
        print(
            '当前选择的日历为:${_userSelectDataModel.month},${_userSelectDataModel.day}');
      });
      print('跳转到当前日期');
      controller.moveToCalendar(dataTime.year, dataTime.month, dataTime.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _calendarSwitchBarWidget(),
      body: Container(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              _currentYearAndMonth(),
              SliverToBoxAdapter(
                child: calendar,
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Text(
                    ' $_selectDate ',
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ),
              ),
              _isMonthSelected
                  ? SliverToBoxAdapter()
                  : ProcessTimeWidget(
                      year: _userSelectDataModel.year,
                      month: _userSelectDataModel.month,
                      day: _userSelectDataModel.day,
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

  Widget _currentYearAndMonth() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        height: AutoLayout.instance.pxToDp(60),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(25),
            right: ScreenUtil().setWidth(25),
            top: AutoLayout.instance.pxToDp(24),
            bottom: AutoLayout.instance.pxToDp(20)),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(100)),
        child: Text(
          '${_userSelectDataModel.year}年${_userSelectDataModel.month}月',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(29),
              color: ColorConstant.blueTextColor),
        ),
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
                controller.weekAndMonthViewChange(
                    CalendarConstants.MODE_SHOW_ONLY_MONTH);
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
                controller.weekAndMonthViewChange(
                    CalendarConstants.MODE_SHOW_ONLY_WEEK);
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
}
