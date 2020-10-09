import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttermarketingplus/login/select_business.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_Initiate_factory_handedOver.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_Initiate_factory_notReceived.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_Initiate_store_handedOver.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_Initiate_store_notReceived.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_receive_factory_handedOver.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_receive_factory_notReceived.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_receive_store_handedOver.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_detail/delivery_order_detail_receive_store_notReceived.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/package_information.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/scan_qr_view.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/transport_line.dart';
import 'package:fluttermarketingplus/navigator/my_page/dot_manage_page/brother_achievement_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/dot_manage_page/add_consumer_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/column_item_page/my_consumer_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/attendance_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/dot_manage_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/dot_manage_page/add_task_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/dot_manage_page/deliver_achievement_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/my_commission_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/my_canva_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/my_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/show_report_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/show_report_page/praise_number_page.dart';
import 'package:fluttermarketingplus/navigator/order_page/add_task_count_page.dart';
import 'package:fluttermarketingplus/navigator/order_page/customer_management_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_order_page.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_order_create.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_order_Initiate.dart';
import 'package:fluttermarketingplus/navigator/my_page/delivery_order/delivery_order_filter_page.dart';
import 'package:fluttermarketingplus/navigator/special_home_page/special_home_page.dart';

Handler addConsumerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String data = params['data'].first;
  return AddConsumerPage(consumerData: data);
});

Handler myAttendanceHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String data = params['titledata'].first;
  return AttendancePage(titleData: data);
});

Handler myCanvasHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String data = params['titledata'].first;
  return MyCanvaPage(titleData: data);
});

Handler myConsumerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String data = params['titledata'].first;
  return MyConsumerPage(titleData: data);
});

Handler addTaskHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddTaskPage();
});
Handler addTaskCountHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddTaskCountPage();
});
Handler dotManageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DotManagePage();
});

Handler customerManagementHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CustomerManagementPage();
});

Handler praiseNumberHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PraiseNumberPage();
});

Handler botherAchievementHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BrotherAchievementPage(
    performance: '网点',
  );
});

Handler myCommissionHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MyCommissionPage();
});

Handler deliverAchievementHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DeliverAchievementPage();
});

Handler  deliveryOrderHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DeliveryOrderPage();
});

Handler  deliveryOrderCreateHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DeliveryOrderCreate();
});

Handler  deliveryOrderReceiveOrInitiateHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String data = params['data'].first;
  return DeliveryOrderReceiveOrInitiate(receiveOrInitiate: data,);
});

Handler  deliveryOrderFilterPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DeliveryOrderFilterPage();
});

Handler  deliveryOrderDetailReceiveStoreNotReceivedPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailReceiveStoreNotReceived(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailReceiveFactoryNotReveivedPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailReceiveFactoryNotReveived(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailReceiveStoreHandedOverPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailReceiveStoreHandedOver(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailReceiveFactoryHandedOverPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailReceiveFactoryHandedOver(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailInitiateStoreNotReceivedPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailInitiateStoreNotReceived(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailInitiateFactoryNotReceivedPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailInitiateFactoryNotReceived(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailInitiateStoreHandedOverPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailInitiateStoreHandedOver(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderDetailInitiateFactoryHandedOverPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return DeliveryOrderDetailInitiateFactoryHandedOver(deliveryOrderModelString:deliveryOrderModelString);
});

Handler  deliveryOrderScanQrPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    // String flag = params['flag'].first;
    // String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return ScanQrView();
});

Handler  selectBusinessPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String role = params['role'].first;
    String fromPage = params['fromPage'].first;
  return SelectBusiness(role:role,fromPage: fromPage,);
});

Handler  showReportPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    // String flag = params['flag'].first;
    // String deliveryOrderModelString = params['deliveryOrderModelString'].first;
  return ShowReportPage();
});

Handler  myPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MyPage();
});

Handler  transportLineHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TransportLine();
});

Handler  specialHomeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SpecialHomePage();
});

Handler  packageInformationHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String packageInformation = params['packageInformation'].first;
  return PackageInformation(packageInformation: packageInformation);
});

