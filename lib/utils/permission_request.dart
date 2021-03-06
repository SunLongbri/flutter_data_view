import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  final permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.location]);

  if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
    return true;
  } else {
    showToast('需要定位权限!');
    return false;
  }
}
