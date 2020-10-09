//全局存放的静态数据
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData {
  static SharedPreferences prefs;
  static String UNAUTHORIZED_TOKEN = '10002';
  static int REQUEST_SUCCESS = 200;
  static int BAD_REQUEST = 400;
}

//字符串block
typedef VoidStringCallback = void Function(String);
//字符数组block
typedef ListStringCallBack = void Function(List<String>);
//函数block
typedef VoidFunctionCallback = void Function(Function);

typedef AmapControllerCallback = void Function(AmapController);
