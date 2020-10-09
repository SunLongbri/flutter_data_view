import 'dart:convert';
import 'dart:math';

import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/login/login_page.dart';
import 'package:fluttermarketingplus/model/add_consumer_model.dart';
import 'package:fluttermarketingplus/model/comment_response_model.dart';
import 'package:fluttermarketingplus/routers/jump_receive.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/match_input.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';
import 'package:oktoast/oktoast.dart';

//添加新用户页面
class AddConsumerPage extends StatefulWidget {
  //从上个页面传递过来的参数
  final String consumerData;

  const AddConsumerPage({Key key, this.consumerData}) : super(key: key);

  @override
  _AddConsumerPageState createState() => _AddConsumerPageState();
}

class _AddConsumerPageState extends State<AddConsumerPage> {
  //焦点控制器
  FocusNode _commentFocus = FocusNode();

  //用户数据
  String _consumerData;

  //姓名控制器
  TextEditingController _nameController;

  //性别控制器
  String _genderController;

  //性别选项列表
  List<String> _genderOptions;

  //手机号码控制器
  TextEditingController _phoneController;

  //地址控制器
  TextEditingController _addressController;

  //衣服控制器
  TextEditingController _clothesColorController;

  List<String> _clothesOptions;

  //衣服品质控制器
  String _qualityController; // 1：普通衣物；2：贵重衣物；3：奢侈衣物

  //品牌控制器
  TextEditingController _brandController;

  AddConsumerModel _addConsumerModel;

  @override
  void initState() {
    _consumerData = JumpReceive().receive(widget.consumerData);
    _addConsumerModel = AddConsumerModel();
    _nameController = TextEditingController();
    _genderController = '请选择性别';
    _genderOptions = ['男', '女'];
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _addressController = TextEditingController();
    _clothesColorController = TextEditingController();
    _clothesOptions = ['普通衣物', '名贵衣物'];
    _qualityController = '请选择品质';
    _brandController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: _consumerData,
        backPress: (){
          if(_consumerData.compareTo('录入客户信息') == 0){
            AlertDialogWidget(title: '是否放弃录入信息?').show(context).then((val){
              if(val.compareTo('确定') == 0){
                Navigator.pop(context);
              }
            });
          }else{
            Navigator.pop(context);
          }
        },
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          //键盘回收
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onHorizontalDragEnd: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onVerticalDragEnd: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _rowLine('姓名', '请输入你的姓名', _nameController),
                _popSelect('性别', _genderController, _genderOptions),
                _rowLine('电话', '请输入你的号码', _phoneController),
                _popSelectWidget('城市', _userSelectCity, () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Result result = await CityPickers.showCityPicker(
                    height: AutoLayout.instance.pxToDp(600),
                    context: context,
                  );
                  _addConsumerModel.province = result.provinceName;
                  _addConsumerModel.city = result.cityName;
                  _addConsumerModel.area = result.areaName;
                  setState(() {
                    _userSelectCity =
                        '${result.provinceName}${result.cityName}${result.areaName}';
                  });
                }),
                _rowLine('详细地址', '请输入详细地址', _addressController),
                _rowLine('衣服颜色', '请输入衣服颜色', _clothesColorController),
                _popSelectWidget('衣服品质', _qualityController, () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  BottomCupertionWidget(listContent: [
                    '普通衣物',
                    '贵重衣物',
                    '奢侈衣物',
                  ]).selectData(context).then((val) {
                    if (val == null) {
                      return;
                    }
                    setState(() {
                      _qualityController = val;
                    });
                  });
                }),
                _rowLine('衣服品牌', '请输入衣服品牌', _brandController),
                _submitBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //保存按钮
  Widget _submitBtn() {
    return Container(
      height: AutoLayout.instance.pxToDp(60),
      width: ScreenUtil().setWidth(345),
      margin: EdgeInsets.only(top: AutoLayout.instance.pxToDp(151)),
      child: FlatButton(
          color: ColorConstant.blueTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onPressed: onSubmitMethod,
          child: Text(
            '保存',
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(30)),
          )),
    );
  }

  //提交方法
  void onSubmitMethod() {
    String name = _nameController.text.toString().trim();
    String phone = _phoneController.text.toString().trim();
    String detailAddress = _addressController.text.toString().trim();
    String clothesQuality = _clothesColorController.text.toString().trim();
    String clothesColor = _clothesColorController.text.toString().trim();
    String brand = _brandController.text.toString().trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        detailAddress.isEmpty ||
        clothesColor.isEmpty ||
        clothesQuality.isEmpty ||
        brand.isEmpty ||
        _userSelectCity.contains('请选择你的城市')) {
      showToast('请填写完整信息!');
      return;
    }

    if (!MatchInput.isChinaPhoneLegal(phone)) {
      showToast('请填写正确的手机号!');
      return;
    }

    if (_selectType.compareTo('男') == 0) {
      _addConsumerModel.sex = '1';
    } else {
      _addConsumerModel.sex = '2';
    }
    _addConsumerModel.userName = name;
    _addConsumerModel.tel = phone;
    _addConsumerModel.address = detailAddress;
    _addConsumerModel.color = clothesQuality;
    if (_qualityController.compareTo('普通衣物') == 0) {
      _addConsumerModel.character = '1';
    } else if (_qualityController.compareTo('贵重衣物') == 0) {
      _addConsumerModel.character = '2';
    } else if (_qualityController.compareTo('奢侈衣物') == 0) {
      _addConsumerModel.character = '3';
    }
    _addConsumerModel.brand = brand;
    int uri = Random(500).nextInt(10000);
    _addConsumerModel.userId = uri.toString();
    print('即将上传的数据模型:${json.encode(_addConsumerModel)}');
    postRequest(API.ADD_CUSTOM_INFO, json.encode(_addConsumerModel))
        .then((val) {
      print('post返回的数据为:${val}');
      CommentResponseModel commentResponseModel =
          CommentResponseModel.fromJson(val);
      if (commentResponseModel.code == GlobalData.UNAUTHORIZED_TOKEN) {
        //token失效
        AlertDialogWidget(title: '登陆过期,请重新登陆!').show(context).then((val) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        });
      } else if (commentResponseModel.status == GlobalData.REQUEST_SUCCESS) {
        AlertDialogWidget(title: '添加用户成功').show(context).then((val) {
          Navigator.pop(context);
        });
      } else if (commentResponseModel.status == 402) {
        AlertDialogWidget(title: commentResponseModel.info)
            .show(context)
            .then((val) {
          print('val:${val}');
        });
      } else if (commentResponseModel.status == 500) {
        AlertDialogWidget(title: '系统开小车了!').show(context).then((val) {
          print('val:${val}');
        });
      }
    });
  }

  String _userSelectCity = '请选择你的城市';

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              child: Row(
                children: [
                  Text(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorConstant.hintTextColor,
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

  Widget _popSelect(String title, String headController, List<String> options) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(28), right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Container(
            width: ScreenUtil().setWidth(220),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _singleRadio('男'),
                _singleRadio('女'),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _selectType = 'x';

  //单行选择框
  Widget _singleRadio(String content) {
    return Container(
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(40),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            child: Radio(
              value: content,
              groupValue: _selectType,
              onChanged: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _selectType = value;
                });
              },
            ),
          ),
          Text(content),
        ],
      ),
    );
  }

  //单行样式
  Widget _rowLine(
      String text, String hintText, TextEditingController controller) {
    TextInputType keyboardType = TextInputType.text;
    if (hintText.contains('号码')) {
      keyboardType = TextInputType.number;
    }
    return Container(
      height: AutoLayout.instance.pxToDp(98),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(28),
        right: ScreenUtil().setWidth(28),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: ColorConstant.greyLineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Container(
            width: ScreenUtil().setWidth(220),
            child: TextField(
              keyboardType: keyboardType,
              style: TextStyle(
                  color: ColorConstant.greyTextColor,
                  fontSize: ScreenUtil().setSp(26)),
              cursorColor: ColorConstant.greyLineColor,
              controller: controller,
              maxLength: 50,
              buildCounter: _counter,
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: ColorConstant.hintTextColor,
                      fontSize: ScreenUtil().setSp(26)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(5))),
            ),
          )
        ],
      ),
    );
  }

  Widget _counter(
      BuildContext context, {
        int currentLength,
        int maxLength,
        bool isFocused,
      }) {
    return Container(
      height: 1,
    );
  }
}
