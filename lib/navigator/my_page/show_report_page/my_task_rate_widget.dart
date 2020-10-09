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
class MYTaskRateWidget extends StatefulWidget {
  @override
  _MYTaskRateWidgetState createState() => _MYTaskRateWidgetState();
}

class _MYTaskRateWidgetState extends State<MYTaskRateWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double valueData = 40;

  @override
  void initState() {
    super.initState();
  }

  DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: AutoLayout.instance.pxToDp(470)),
      child: Container(
        key: _scaffoldKey,
        width: 750,
        height: AutoLayout.instance.pxToDp(470),
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
            data: [{value: ${dataProvider.taskRate}, name: '完成率'}]
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
    );
  }
}
