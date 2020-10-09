import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fluttermarketingplus/constant/global_data.dart';
import 'package:fluttermarketingplus/service/API.dart';
import 'package:oktoast/oktoast.dart';

//get 请求方法
Future getRequest(String url,
    {Map<String, String> queryParameters, String tempBaseUrl = ''}) async {
  Dio dio = Dio();
  String accessToken = GlobalData.prefs?.getString('accessToken') ?? '';
  if (accessToken.isNotEmpty) {
    dio.options.headers["Authorization"] = accessToken;
  }
  //在上文dio使用的代码中加入如下代码，即添加了Log拦截器
  dio.interceptors.add(LogInterceptor());
  //设置代理
  DefaultHttpClientAdapter adapter = dio.httpClientAdapter;
  adapter.onHttpClientCreate = (HttpClient client) {
    if (client == null) {
      client = HttpClient();
    }
    client.findProxy = (url) {
      return HttpClient.findProxyFromEnvironment(url, environment: {
        "http_proxy": tempBaseUrl.isEmpty ? API.BASE_URL : tempBaseUrl,
      });
    };
    return client;
  };
  dio.options.baseUrl = tempBaseUrl.isEmpty ? API.BASE_URL : tempBaseUrl;
  //设置连接超时时间
  dio.options.connectTimeout = 20000;
  //设置数据接收超时时间
  dio.options.receiveTimeout = 20000;
  try {
    //以表单的形式设置请求参数
    Response response = await dio.get(url, queryParameters: queryParameters);
    if (response.statusCode == GlobalData.REQUEST_SUCCESS) {
      print('请求成功');
//      var responseData = response.data.toString();
//      responseData = responseData.replaceAll("{", "\n{");
//      debugPrint('response.data=$responseData');
      return response.data;
    }
  } on DioError catch (e) {
    print("exception: $e");
    showToast('网络失去连接了!');
  }
}

//带参数的post请求
Future postRequest(String url, formData, {String tempBaseUrl = ''}) async {
  try {
    Response response;
    Dio dio = Dio();
    String accessToken = GlobalData.prefs?.getString('accessToken') ?? '';
    if (accessToken.isNotEmpty) {
      dio.options.headers["Authorization"] = accessToken;
    }
    //在上文dio使用的代码中加入如下代码，即添加了Log拦截器
    dio.interceptors.add(LogInterceptor());
    //设置代理
    DefaultHttpClientAdapter adapter = dio.httpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      if (client == null) {
        client = HttpClient();
      }
      client.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {
          "http_proxy": tempBaseUrl.isEmpty ? API.BASE_URL : tempBaseUrl,
        });
      };
      return client;
    };
    dio.options.baseUrl = tempBaseUrl.isEmpty ? API.BASE_URL : tempBaseUrl;
    //设置连接超时时间
    dio.options.connectTimeout = 10000;
    //设置数据接收超时时间
    dio.options.receiveTimeout = 10000;


    response = await dio.post(url, data: formData);
    print('带参数的post为:${response.toString()}');
    if (response.statusCode == GlobalData.REQUEST_SUCCESS) {
      return response.data;
    } else {
      print('带参数的post请求异常:响应码为:${response.statusCode}');
    }
  } on DioError catch (e) {
    print("exception: $e");
    showToast('网络失去连接了!');
  }
}

//带参数的post请求
Future postFileRequest(String url, formData, {String tempBaseUrl = ''}) async {
  try {
    Response response;
    Dio dio = Dio();
    String accessToken = GlobalData.prefs?.getString('accessToken') ?? '';
    if (accessToken.isNotEmpty) {
      dio.options.headers["Authorization"] = accessToken;
    }
    //在上文dio使用的代码中加入如下代码，即添加了Log拦截器
    dio.interceptors.add(LogInterceptor());
    //设置代理
    DefaultHttpClientAdapter adapter = dio.httpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      if (client == null) {
        client = HttpClient();
      }
      client.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {
          "http_proxy": tempBaseUrl.isEmpty ? API.BASE_URL : tempBaseUrl,
        });
      };
      return client;
    };
    dio.options.baseUrl = tempBaseUrl.isEmpty ? API.BASE_URL : tempBaseUrl;
    //设置连接超时时间
    dio.options.connectTimeout = 20000;
    //设置数据接收超时时间
    dio.options.receiveTimeout = 20000;


    response = await dio.post(url, data: formData,options: Options(contentType: "multipart/form-data"),);
    print('带参数的post为:${response.toString()}');
    if (response.statusCode == GlobalData.REQUEST_SUCCESS) {
      return response.data;
    } else {
      print('带参数的post请求异常:响应码为:${response.statusCode}');
    }
  } on DioError catch (e) {
    print("exception: $e");
    showToast('网络失去连接了!');
  }
}
