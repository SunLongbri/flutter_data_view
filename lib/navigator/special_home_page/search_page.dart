import 'package:flutter/material.dart';
import 'package:fluttermarketingplus/model/order_list_model.dart';
import 'package:fluttermarketingplus/model/search_by_phone_model.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:fluttermarketingplus/service/service_method.dart';
import 'package:fluttermarketingplus/utils/match_input.dart';
import 'package:fluttermarketingplus/widgets/loading_container.dart';
import 'package:oktoast/oktoast.dart';
import 'home_amap_widgets/single_order_widget.dart';
import 'search_page_widgets/search_bar_widget.dart';

//搜索页面
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<OrderDetailList> _orderDetailList;
  bool _isLoading;

  @override
  void initState() {
    _orderDetailList = [];
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: LoadingContainer(
          isLoading: _isLoading,
          cover: true,
          child: Column(
            children: <Widget>[
              SearchBarWidget(
                block: (val) {
//                  if (MatchInput.isChinaPhoneLegal(val)) {
                  _searchByPhone(val);
//                  } else {
//                    showToast('请输入正确的手机号!');
//                  }
                },
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      itemCount: _orderDetailList.length,
                      itemBuilder: (BuildContext context, int position) {
                        return SingleOrderWidget(
                          orderDetail: _orderDetailList[position],
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _searchByPhone(String number) {
    var formData = {"number": number};
    setState(() {
      _orderDetailList.clear();
      _isLoading = true;
    });
    print('根据手机号搜索:${formData.toString()}');
    postRequest(API.SEARCH_BY_PHONE, formData, tempBaseUrl: API.TEST_BASE_URL)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      SearchByPhoneModel _searchByPhoneModel =
          SearchByPhoneModel.fromJson(value);
      if (_searchByPhoneModel.code == 200) {
        setState(() {
          _orderDetailList =
              _searchByPhoneModel.data.orderListByPhone.orderDetailList;
          if (_orderDetailList.isEmpty) {
            showToast('搜索内容为空!');
          }
        });
      }
    });
  }
}
