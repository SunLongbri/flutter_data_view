import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

import 'router_handler.dart';

class Routes {
  static String root = '/';
  static String addConsumerPage = '/addConsumerPage';
  static String myConsumerPage='/myConsumerPage';
  static String myAttendancePage='/myAttendancePage';
  static String myCanvasPage='/myCanvasPage';
  static String addTaskPage='/addTaskPage';
  static String addTaskCountPage='/addTaskCountPage';
  static String dotManagePage='/dotManagePage';
  static String customerManagementPage='/customerManagementPage';
  static String praiseNumberPage='/praiseNumberPage';
  static String botherAchievementPage='/botherAchievementPage';
  static String myCommissionPage='/myCommissionPage';
  static String deliverAchievementPage='/deliverAchievementPage';
  static String showReportPage='/showReportPage';//小哥报表
  static String deliveryOrderPage='/deliveryOrderPage';//交接单
  static String deliveryOrderCreatePage='/deliveryOrderCreatePage';//创建交接单
  static String deliveryOrderReceiveOrInitiatePage='/deliveryOrderReceiveOrInitiatePage';//我发起的交接单
  static String deliveryOrderFilterPage='/deliveryOrderFilterPage';//我发起的交接单
  //我收到的交接单 待接收 门店至干线
  static String deliveryOrderDetailReceiveStoreNotReceivedPage='/deliveryOrderDetailReceiveStoreNotReceivedPage';
  //我收到的交接单 待接收 工厂至干线
  static String deliveryOrderDetailReceiveFactoryNotReveivedPage='/deliveryOrderDetailReceiveFactoryNotReveivedPage';
  //我收到的交接单 已交接 门店至干线
  static String deliveryOrderDetailReceiveStoreHandedOverPage='/deliveryOrderDetailReceiveStoreHandedOverPage';
  //我收到的交接单 已交接 工厂至干线
  static String deliveryOrderDetailReceiveFactoryHandedOverPage='/deliveryOrderDetailReceiveFactoryHandedOverPage';
   //我发起的交接单 待交接 干线到门店
  static String deliveryOrderDetailInitiateStoreNotReceivedPage='/deliveryOrderDetailInitiateStoreNotReceivedPage';
  //我发起的交接单 待交接 干线到工厂
  static String deliveryOrderDetailInitiateFactoryNotReceivedPage='/deliveryOrderDetailInitiateFactoryNotReceivedPage';
  //我发起的交接单 已交接 干线到门店
  static String deliveryOrderDetailInitiateStoreHandedOverPage='/deliveryOrderDetailInitiateStoreHandedOverPage';
  //我发起的交接单 已交接 干线到工厂
  static String deliveryOrderDetailInitiateFactoryHandedOverPage='/deliveryOrderDetailInitiateFactoryHandedOverPage';

  // DeliveryOrderDetailReceiveStoreNotReceived
  static String deliveryOrderScanQrPage='/deliveryOrderScanQrPage';//交接单扫码
  // DeliveryOrderDetailReceiveStoreNotReceived
  static String selectBusinessPage='/selectBusiness';//选择业务
  // 我的界面
  static String myPage = '/myPage';
  // 干线线路界面
  static String transportLine = '/transportLine';
  static String specialHomePage = '/specialHomePage';
  static String packageInformation = '/packageInformation';

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print('ERROR ==== > ROUTE WAS NOT FOUND!');
          return null;
        });
    router.define(addConsumerPage, handler: addConsumerHandler);
    router.define(myAttendancePage, handler: myAttendanceHandler);
    router.define(myCanvasPage, handler: myCanvasHandler);
    router.define(myConsumerPage, handler: myConsumerHandler);
    router.define(addTaskPage, handler: addTaskHandler);
    router.define(addTaskCountPage, handler: addTaskCountHandler);
    router.define(dotManagePage, handler: dotManageHandler);
    router.define(customerManagementPage, handler: customerManagementHandler);
    router.define(praiseNumberPage, handler: praiseNumberHandler);
    router.define(botherAchievementPage, handler: botherAchievementHandler);
    router.define(myCommissionPage, handler: myCommissionHandler);
    router.define(deliverAchievementPage, handler: deliverAchievementHandler);
    router.define(deliveryOrderPage, handler: deliveryOrderHandler);
    router.define(deliveryOrderCreatePage, handler: deliveryOrderCreateHandler);
    router.define(deliveryOrderReceiveOrInitiatePage, handler: deliveryOrderReceiveOrInitiateHandler);
    router.define(deliveryOrderFilterPage, handler: deliveryOrderFilterPageHandler);
    router.define(deliveryOrderDetailReceiveStoreNotReceivedPage, handler: deliveryOrderDetailReceiveStoreNotReceivedPageHandler);
    router.define(deliveryOrderDetailReceiveFactoryNotReveivedPage, handler: deliveryOrderDetailReceiveFactoryNotReveivedPageHandler);
    router.define(deliveryOrderDetailReceiveStoreHandedOverPage, handler: deliveryOrderDetailReceiveStoreHandedOverPageHandler);
    router.define(deliveryOrderDetailReceiveFactoryHandedOverPage, handler: deliveryOrderDetailReceiveFactoryHandedOverPageHandler);
    router.define(deliveryOrderDetailInitiateStoreNotReceivedPage, handler: deliveryOrderDetailInitiateStoreNotReceivedPageHandler);
    router.define(deliveryOrderDetailInitiateFactoryNotReceivedPage, handler: deliveryOrderDetailInitiateFactoryNotReceivedPageHandler);
    router.define(deliveryOrderDetailInitiateStoreHandedOverPage, handler: deliveryOrderDetailInitiateStoreHandedOverPageHandler);
    router.define(deliveryOrderDetailInitiateFactoryHandedOverPage, handler: deliveryOrderDetailInitiateFactoryHandedOverPageHandler);
    router.define(deliveryOrderScanQrPage, handler: deliveryOrderScanQrPageHandler);
    router.define(selectBusinessPage, handler: selectBusinessPageHandler);
    router.define(myPage, handler: myPageHandler);
    router.define(showReportPage, handler: showReportPageHandler);
    router.define(transportLine, handler: transportLineHandler);
    router.define(specialHomePage, handler: specialHomeHandler);
    router.define(packageInformation, handler: packageInformationHandler);
  }
}
