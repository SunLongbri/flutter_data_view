import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:orientation/orientation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'generated/i18n.dart';
import 'provider/data_provider.dart';
import 'routers/application.dart';
import 'routers/routes.dart';
import 'splash_page.dart';
import 'utils/auto_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    changeStatusColor(Colors.transparent);
    if (Platform.isAndroid) {
      //强制竖屏
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }

  //设置状态栏的颜色
  changeStatusColor(Color color) async {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    if (useWhiteForeground(color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    //屏幕适配，设置底层画稿
    AutoLayout()..init();
    return MultiProvider(
      providers: [
//        ChangeNotifierProvider(builder: (context) => DataProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: _MyApp(),
    );
  }
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    print('当前国际化语言：${dataProvider.isLocal}');
    return OKToast(
        position: ToastPosition.bottom,
        child: MaterialApp(
          onGenerateTitle: (context) {
            return '小哥端';
          },
          locale: dataProvider.isLocal,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
//          localizationsDelegates: const [
//            S.delegate,
//            GlobalMaterialLocalizations.delegate,
//            GlobalWidgetsLocalizations.delegate,
//            GlobalCupertinoLocalizations.delegate,
//            const FallbackCupertinoLocalisationsDelegate(),
//          ],
//          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              ScreenUtil.init(width: 750, height: 1334, allowFontScaling: false);
              return Localizations.override(
                context: context,
                locale: dataProvider.isLocal,
                child: SplashPage(),
              );
            },
          ),
        ));
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
