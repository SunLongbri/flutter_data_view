import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';

class DeliveryOrderFilterPage extends StatefulWidget {
  VoidStringCallback filterBlock;
  DeliveryOrderFilterPage({Key key,this.filterBlock}):super(key: key);
  @override
  _DeliveryOrderFilterPageState createState() => _DeliveryOrderFilterPageState();
}

class _DeliveryOrderFilterPageState extends State<DeliveryOrderFilterPage> {
  TextEditingController _nameController = TextEditingController();
  String _nameString = '';//手动输入条码号
  String _startTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);//开始时间 默认当天
  String _endTime = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);//结束时间 默认当天
  static List<String> checkedItemList = [];
  List<String> selectedItemList = checkedItemList ?? [];
  List<String> _storeList = [
        '北京中关村',
        '北京安贞门',
        '北京朝阳公园',
        '北京西直门',
        '北京三元桥',
        '北京新发地',
        '北京六里桥',
        '北京十里河',
        '北京天通苑',
        '北京上地',
        '北京石景山区',
        'KXBJ01',
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '筛选',
      ),
      body:SingleChildScrollView(
        child: 
      Container(
        color: Colors.white,
        width: 375,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // _searchBarcodeWidget(),
            _rowLine('接收人员:', '请输入接收人姓名', _nameController),
            _popSelectWidget('开始时间:', _startTime, () async {
              DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2015, 1, 1),
                              maxTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            setState(() {
                              //判断开始时间是否比结束时间晚
                              date.isAfter(DateTime.parse(_endTime))
                              ? _startTime = _endTime
                              : _startTime = formatDate(date, [yyyy, '-', mm, '-', dd]);
                            });
                            print('confirm $date $_startTime');
                          }, currentTime: DateTime.parse(_startTime), locale: LocaleType.zh);
            }),
            _popSelectWidget('结束时间:', _endTime, () async {
              DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2015, 1, 1),
                              maxTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            setState(() {
                              //判断结束时间是否比开始时间早
                              date.isBefore(DateTime.parse(_startTime))
                              ? _endTime = _startTime
                              : _endTime = formatDate(date, [yyyy, '-', mm, '-', dd]);
                            });
                            print('confirm $date');
                          }, currentTime: DateTime.parse(_endTime), locale: LocaleType.zh);
            }),
            Container(
              margin: EdgeInsets.only(left: 12, top: 5),
              alignment: Alignment.centerLeft,
              child: Text('所属门店：'),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              margin: EdgeInsets.only(left: 12.0, right: 12.0),
              // height: MediaQuery.of(context).size.height / 4,
              // width: MediaQuery.of(context).size.width,
              child: GroupedCheckbox(
                wrapSpacing: 5.0,
                wrapRunSpacing: 5.0,
                wrapTextDirection: TextDirection.ltr,
                wrapRunAlignment: WrapAlignment.center,
                wrapVerticalDirection: VerticalDirection.down,
                wrapAlignment: WrapAlignment.center,
                itemList: _storeList,
                checkedItemList: checkedItemList,
                disabled: [],
                onChanged: (itemList) {
                  setState(() {
                    selectedItemList = itemList;
                    print('SELECTED ITEM LIST $itemList');
                  });
                },
                orientation: CheckboxOrientation.WRAP,
                checkColor: Colors.purpleAccent,
                activeColor: Colors.lightBlue,
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffff0000), width: 1),
            color: Colors.red,
          ),
          height: 40.0,
          child: _bottomNavigationContainer()
        )
    );
  }


  //单行样式
  Widget _rowLine(
      String text, String hintText, TextEditingController controller) {
    TextInputType keyboardType = TextInputType.text;
    return Container(
      height: 50,
      // width: 600,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 5, right: 12),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(28),
        right: ScreenUtil().setWidth(28),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            child: Text(
              text,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              width: ScreenUtil().setWidth(220),
              child: TextField(
                keyboardType: keyboardType,
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(26)),
                cursorColor: ColorConstant.greyLineColor,
                controller: controller,
                onSubmitted: (String value){
                  _nameString = value;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: ColorConstant.hintTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    /*边角*/
                    borderRadius: BorderRadius.all(
                      Radius.circular(8), //边角为8
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey, 
                      width: 1, //边线宽度为1
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _popSelectWidget(String title, String content, VoidCallback callback) {
    return Container(
      height: AutoLayout.instance.pxToDp(98),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(28), right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            child: Text(
              title,
              style: TextStyle(
                  color: ColorConstant.blackTextColor,
                  fontSize: ScreenUtil().setSp(30)),
            ),
          ),
          InkWell(
            onTap: callback,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: ScreenUtil().setWidth(420),
              child: Row(
                children: [
                  Text(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorConstant.blackTextColor,
                        fontSize: ScreenUtil().setSp(26)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(14),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Image.asset(
                      'images/arrow_down.png',
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomNavigationContainer(){
    return Container(
      child: OutlineButton(
                borderSide: BorderSide(color: Colors.red),
                highlightedBorderColor: Colors.red,
                disabledBorderColor: Colors.red,
                highlightColor: Colors.pink[100],
                onPressed: () {
                  Navigator.pop(context,'{"name":"$_nameString","startTime":"$_startTime","endTime":"$_endTime","selectedItemList":"$selectedItemList"}');
                },
                child: Container(
                  child: Text('确定',style: TextStyle(color: Colors.white),),
                )),
    );
  }

}