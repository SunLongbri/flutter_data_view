import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/pick_up_pages/washing_detail_pages/search_address_page.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';
import 'package:oktoast/oktoast.dart';

//修改地址页面
class EditAddressPage extends StatefulWidget {
  //取送件修改地址的类型
  final String addressType;

  const EditAddressPage({Key key, this.addressType}) : super(key: key);

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController _areaEditingController;
  TextEditingController _locationEditingController;

  @override
  void initState() {
    _areaEditingController = TextEditingController();
    _locationEditingController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '修改地址',
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                top: AutoLayout.instance.pxToDp(20)),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(22)),
            child: Column(
              children: <Widget>[
                _selectCityWidget(),
                _greyLineWidget(),
                _inputAreaWidget(),
                _greyLineWidget(),
                _inputLocationWidget(),
              ],
            ),
          ),
          _submitBtnWidget()
        ],
      ),
    );
  }

  Widget _greyLineWidget() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: AutoLayout.instance.pxToDp(2),
        color: ColorConstant.greyLineColor,
      ),
    );
  }

  Widget _submitBtnWidget() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: AutoLayout.instance.pxToDp(70),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(88),
            right: ScreenUtil().setWidth(88),
            top: AutoLayout.instance.pxToDp(102)),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () {
            showToast('地址确定按钮 ... ');
          },
          color: ColorConstant.blueBgColor,
          child: Text(
            '确定',
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(32)),
          ),
        ),
      ),
    );
  }

  Widget _inputLocationWidget() {
    return Container(
      alignment: Alignment.center,
      height: AutoLayout.instance.pxToDp(104),
      child: Row(
        children: <Widget>[
          Text(
            '详细地址：',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(25)),
          ),
          Expanded(
              child: Container(
            child: TextField(
              controller: _locationEditingController,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ))
        ],
      ),
    );
  }

  Widget _inputAreaWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            '所在地区：',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(25)),
          ),
          Expanded(
              child: Container(
            child: TextField(
              controller: _areaEditingController,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          )),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchAddressPage()));
            },
            child: Container(
              width: ScreenUtil().setWidth(36),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(48)),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'images/address_location.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          )
        ],
      ),
    );
  }

  String _userSelectCity = '';

  Widget _selectCityWidget() {
    return Container(
      height: AutoLayout.instance.pxToDp(102),
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          Text(
            '选择城市：',
            style: TextStyle(
                color: ColorConstant.greyTextColor,
                fontSize: ScreenUtil().setSp(25)),
          ),
          Expanded(
              child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              BottomCupertionWidget(
                      centerTitle: '', listContent: ['上海', '广州', '天津', '马来西亚'])
                  .selectData(context)
                  .then((value) {
                print('选择的城市:${value}');
                if (value != null) {
                  setState(() {
                    _userSelectCity = value;
                  });
                }
              });
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                _userSelectCity,
                style: TextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(25)),
              ),
            ),
          )),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(48)),
            width: ScreenUtil().setWidth(20),
            alignment: Alignment.centerLeft,
            child: Image.asset('images/arrow_right.png'),
          )
        ],
      ),
    );
  }
}
