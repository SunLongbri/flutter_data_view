import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/model/day_count_model.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

//日历-小哥任务-时间轴组件
class ProcessTimeWidget extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final List<Time> time;

  const ProcessTimeWidget({Key key, this.year, this.month, this.day, this.time})
      : super(key: key);

  @override
  _ProcessTimeWidgetState createState() => _ProcessTimeWidgetState();
}

class _ProcessTimeWidgetState extends State<ProcessTimeWidget> {
  int _userSelectPosition = 0; //小哥选择预约的时间
  DataProvider _dataProvider;
  List<Time> _time;
  int _limitHour; //小于当天的小时，颜色至为灰色

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _limitHour = 0;
    DateTime _currentTime = DateTime.now();
    if (_currentTime.year == widget.year &&
        _currentTime.month == widget.month &&
        _currentTime.day == widget.day) {
      _limitHour = _currentTime.hour;
    }

    _time = widget.time ?? [];
    _dataProvider = Provider.of<DataProvider>(context);
    _userSelectPosition = _dataProvider.getUserSelectPosition;
    return Container(
      margin: EdgeInsets.only(
          top: AutoLayout.instance.pxToDp(20),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          bottom: AutoLayout.instance.pxToDp(31)),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 24,
          physics: NeverScrollableScrollPhysics(), //禁止滑动
          itemBuilder: (BuildContext context, int position) {
            return _singleTimeWidget((position + 1));
          }),
    );
  }

  //单个时间组件
  Widget _singleTimeWidget(int position) {
    int washCount = 0;
    String time = '${position}:00';
    String dataTime = '';
    for (int i = 0; i < _time.length; i++) {
      dataTime = _time[i].timeDetail;
      if (dataTime.startsWith('0')) {
        dataTime = dataTime.substring(1, dataTime.length);
      }
      if (dataTime == time) {
        washCount = _time[i].wash;
      }
    }
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (position < (_limitHour + 1)) {
          showToast('当前时间端不可预约!');
          return;
        }
        String _selectTime =
            '${widget.year}-${widget.month}-${widget.day} ${position}:00';
        _dataProvider.setSelectTime = _selectTime;
        showToast(_selectTime);
        _dataProvider.setUserSelectPosition = position;
      },
      child: Container(
        color: Colors.white,
        height: AutoLayout.instance.pxToDp(94),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(26)),
              width: ScreenUtil().setWidth(29),
              child: position == _userSelectPosition
                  ? Image.asset(
                      'images/process_light.png',
                      fit: BoxFit.fitWidth,
                    )
                  : Image.asset(
                      'images/process_dark.png',
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Expanded(
                child: Container(
              height: AutoLayout.instance.pxToDp(94),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorConstant.greyLineColor))),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(26),
                  right: ScreenUtil().setWidth(46)),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      '${position}:00',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(29),
                          color: position < (_limitHour + 1)
                              ? ColorConstant.greyLineColor
                              : position == _userSelectPosition
                                  ? ColorConstant.blueTextColor
                                  : ColorConstant.blackTextColor),
                    ),
                  ),
                  washCount == 0
                      ? Container()
                      : Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(38)),
                          width: ScreenUtil().setWidth(29),
                          child: Image.asset(
                            'images/kinds_jacket_icon.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                  washCount == 0
                      ? Container()
                      : Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                          child: Text(
                            'x${washCount}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(29),
                                color: ColorConstant.blackTextColor),
                          ),
                        ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
