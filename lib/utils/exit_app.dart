import 'package:oktoast/oktoast.dart';

DateTime _lastPressedAt; //上次点击时间
//退出app
Future<bool> exitApp() {
  if (_lastPressedAt == null ||
      DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
    showToast("再按一次退出应用");
    //两次点击间隔超过2秒则重新计时
    _lastPressedAt = DateTime.now();
    return Future.value(false);
  }

  return Future.value(true);
}