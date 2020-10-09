import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/provider/data_provider.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:number_display/number_display.dart';
import 'package:provider/provider.dart';

final display = createDisplay(decimal: 2);

//任务完成率图表
class TaskRateWidget extends StatefulWidget {
  final double rate;
  final String sub; //偏离值

  const TaskRateWidget({Key key, this.rate, this.sub}) : super(key: key);

  @override
  _TaskRateWidgetState createState() => _TaskRateWidgetState();
}

class _TaskRateWidgetState extends State<TaskRateWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double valueData = 40;
  DataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    valueData = widget.rate;
  }

  @override
  Widget build(BuildContext context) {
    _dataProvider = Provider.of<DataProvider>(context);
    return Container(
      key: _scaffoldKey,
      width: 750,
      height: AutoLayout.instance.pxToDp(470),
      child: Stack(
        children: [
          Container(
            width: ScreenUtil().setWidth(600),
            alignment: Alignment.centerLeft,
            child: Echarts(
              option: '''
                    {
    tooltip: {
        formatter: '{a} <br/>{b} : {c}%'
    },
    series: [
        {
            name: '业务指标',
            type: 'gauge',
            detail: {formatter: '{value}%'},
            data: [{value: ${_dataProvider.dotRate}, name: '完成率'}]
        }
    ]
}
                  ''',
              extraScript: '''
                    chart.on('click', (params) => {
                      if(params.componentType === 'series') {
                        Messager.postMessage(JSON.stringify({
                          type: 'select',
                          payload: params.dataIndex,
                        }));
                      }
                    });
                  ''',
              onMessage: (String message) {
                Map<String, Object> messageAction = jsonDecode(message);
                print(messageAction);
              },
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(600),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '偏离值${widget.sub}单',
                style: TextStyle(
                    color: ColorConstant.deepRedTextColor,
                    fontSize: ScreenUtil().setSp(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
