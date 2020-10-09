import 'dart:convert';
import 'dart:math';

import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttermarketingplus/constant/color_constant.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/model/add_consumer_model.dart';
import 'package:fluttermarketingplus/model/comment_response_model.dart';
import 'package:fluttermarketingplus/model/customer_detail_upload_model.dart';
import 'package:fluttermarketingplus/model/my_customer_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/auto_layout.dart';
import 'package:fluttermarketingplus/utils/match_input.dart';
import 'package:fluttermarketingplus/widgets/alert_dialog_widget.dart';
import 'package:fluttermarketingplus/widgets/appbar_widget.dart';
import 'package:fluttermarketingplus/widgets/bottom_cupertion_widget.dart';
import 'package:oktoast/oktoast.dart';

class MyConsumeDetailsPage extends StatefulWidget {
  final DataList customerData;

  const MyConsumeDetailsPage(this.customerData, {Key key}) : super(key: key);

  @override
  _MyConsumeDetailsPageState createState() => _MyConsumeDetailsPageState();
}

class _MyConsumeDetailsPageState extends State<MyConsumeDetailsPage> {
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

  //修改用户信息数据模型
  CustomerDetailUploadModel _editConsumerModel;

  //品牌控制器
  TextEditingController _brandController;

  String _selectType;

  @override
  void initState() {
    super.initState();
    _editConsumerModel = CustomerDetailUploadModel();
    _nameController = TextEditingController(text: widget.customerData.userName);
    _genderController =
        widget.customerData.sex.toString().compareTo('1') == 0 ? '男' : '女';
    _selectType = _genderController;
    _genderOptions = ['男', '女'];
    _phoneController = TextEditingController(text: widget.customerData.tel);
    _addressController = TextEditingController(
        text: widget.customerData.address.split(widget.customerData.area)[1]);
    _clothesColorController =
        TextEditingController(text: widget.customerData.color);
    _clothesOptions = ['普通衣物', '名贵衣物'];
    _qualityController =
        widget.customerData.characters.toString().compareTo('1') == 0
            ? '普通衣物'
            : widget.customerData.characters.toString().compareTo('2') == 0
                ? '贵重衣物'
                : '奢侈衣物';
    _brandController = TextEditingController(text: widget.customerData.brand);
    _userSelectCity =
        widget.customerData.address.split(widget.customerData.area)[0] +
            '${widget.customerData.area}';

    _editConsumerModel.id = widget.customerData.id.toString();
    _editConsumerModel.userName = widget.customerData.userName;
    _editConsumerModel.sex = widget.customerData.sex.toString();
    _editConsumerModel.tel = widget.customerData.tel;
    _editConsumerModel.province = widget.customerData.province;
    _editConsumerModel.city = widget.customerData.city;
    _editConsumerModel.area = widget.customerData.area;
    _editConsumerModel.address =
        widget.customerData.address.split(widget.customerData.area)[1];
    _editConsumerModel.color = widget.customerData.color;
    _editConsumerModel.characters = widget.customerData.characters.toString();
    _editConsumerModel.brand = widget.customerData.brand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '客户详情',
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
                  Result result = await CityPickers.showCityPicker(
                    height: AutoLayout.instance.pxToDp(600),
                    context: context,
                  );
                  _editConsumerModel.province = result.provinceName;
                  _editConsumerModel.city = result.cityName;
                  _editConsumerModel.area = result.areaName;
                  setState(() {
                    _userSelectCity =
                        '${result.provinceName}${result.cityName}${result.areaName}';
                  });
                }),
                _rowLine('详细地址', '请输入详细地址', _addressController),
                _rowLine('衣服颜色', '请输入衣服颜色', _clothesColorController),
                _popSelectWidget('衣服品质', _qualityController, () {
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
    AlertDialogWidget(title: '是否修改当前用户信息?', showCancel: true)
        .show(context)
        .then((val) {
      if (val.compareTo('取消') == 0) {
        return;
      }
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
        _editConsumerModel.sex = '1';
      } else {
        _editConsumerModel.sex = '2';
      }
      _editConsumerModel.userName = name;
      _editConsumerModel.tel = phone;
      _editConsumerModel.address = detailAddress;
      _editConsumerModel.color = clothesQuality;
      if (_qualityController.compareTo('普通衣物') == 0) {
        _editConsumerModel.characters = '1';
      } else if (_qualityController.compareTo('贵重衣物') == 0) {
        _editConsumerModel.characters = '2';
      } else if (_qualityController.compareTo('奢侈衣物') == 0) {
        _editConsumerModel.characters = '3';
      }
      _editConsumerModel.brand = brand;
      print('即将上传的数据模型:${json.encode(_editConsumerModel)}');
      postRequest(API.MY_CUSTOMER_EDIT, json.encode(_editConsumerModel))
          .then((val) {
        print('post返回的数据为:${val}');
        CommentResponseModel commentResponseModel =
            CommentResponseModel.fromJson(val);
        if (commentResponseModel.status == GlobalData.REQUEST_SUCCESS) {
          AlertDialogWidget(title: '修改用户成功').show(context).then((val) {
            Navigator.pop(context, 'exit');
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
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: TextField(
                keyboardType: keyboardType,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: ColorConstant.greyTextColor,
                    fontSize: ScreenUtil().setSp(26)),
                cursorColor: ColorConstant.greyLineColor,
                controller: controller,
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: ColorConstant.hintTextColor,
                        fontSize: ScreenUtil().setSp(26)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: AutoLayout.instance.pxToDp(10),
                        left: ScreenUtil().setWidth(5))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
