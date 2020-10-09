typedef RequestCallBack<T> = void Function(T value);

class API {
  //网址---予发布
  static const BASE_URL = 'https://tt3.24tidy.com';

  //网址---线上环境
//  static const BASE_URL = 'https://tt.24tidy.com';
  //郭帆本地测试
//  static const GUO_BASE_URL = 'http://192.168.40.230:8850';

  //测试接口网址
//  static const TEST_BASE_URL = 'http://192.168.40.238:8840';

  //测试接口网址
  static const TEST_BASE_URL = 'https://tt.24tidy.com/api/tidy24/xiaoge';

  ///登陆服务
  static const LOGIN_SERVICE = '/api/tidy24/admin/user';

  ///小哥服务
  static const XIAOGE_SERVICE = '/api/tidy24/xiaoge';

  ///商城服务
  static const STORE_SERVICE = '/api/tidy24/store';

  ///登陆
  static const String LOGIN = LOGIN_SERVICE + '/xiaoge/login';

  ///报表页地图
  static const String REPORT_MY_TASK = XIAOGE_SERVICE + '/shopper/tasks';

  ///报表页地图表示
  static const String REPORT_MAP_LOCATION = XIAOGE_SERVICE + '/xiaoge/usermap';

  ///小哥或店长添加客户
  static const String ADD_CUSTOM_INFO = XIAOGE_SERVICE + '/xiaoge/customerinfo';

  ///昨日战况
  static const String YESTERDAY_WAR_INFO =
      XIAOGE_SERVICE + '/shopper/achievementdetail';

  ///任务达成率
  static const String MY_TASK_RATE = XIAOGE_SERVICE + '/shopper/ratio';

  ///单量和实收金额分布
  static const String AMOUNT_DISTRIBUTION =
      XIAOGE_SERVICE + '/shopper/histogram';

  ///店长新增任务--小哥姓名
  static const String ADD_TASK_LIST = XIAOGE_SERVICE + '/dianzhang/xiaogeinfo';

  ///新增任务量
  static const String ADD_TASK_UPLOAD =
      XIAOGE_SERVICE + '/dianzhang/worktasklist';

  ///展示门店下所有小哥任务
  static const String STORE_DELIVERS_TASK =
      XIAOGE_SERVICE + '/dianzhang/xiaogeworktask';

  ///网点昨日业绩--鲜花、洗涤
  static const String DOT_YESTERDAY_ACHIEVEMENT =
      XIAOGE_SERVICE + '/dianzhang/workpower';

  ///小哥营销情况
  static const String DELIVER_BUSINESS_ENV =
      XIAOGE_SERVICE + '/dianzhang/xiaogemarketinfo';

  ///我的-网点管理报表-达成率-menuButton菜单
  static const String DOT_RATE_MENU = XIAOGE_SERVICE + '/dianzhang/stationinfo';

  ///我的-网点管理报表-达成率-显示
  static const String DOT_RATE = XIAOGE_SERVICE + '/dianzhang/achieverate';

  ///我的 - 网点管理报表 - 数据统计
  static const String DOT_STATISTICS =
      XIAOGE_SERVICE + '/dianzhang/xiaogeservicedata';

  ///我的-网点管理报表-客户管理-门店小哥查询
  static const String DOT_MANAGE_DELIVER =
      XIAOGE_SERVICE + '/dianzhang/xiaogeinfo';

  ///我的-网点管理报表-客户管理-首页初始化数据以及门店小哥筛选
  static const String DOT_MANAGE_SEARCH =
      XIAOGE_SERVICE + '/dianzhang/xiaogecustomer';

  ///我的-网点管理报表-客户管理-根据姓名，电话，地址等搜索
  static const String DOT_MANAGE_TYPE_SEARCH =
      XIAOGE_SERVICE + '/dianzhang/xiaogecustomerexp';

  ///我的-我的二维码-获取小哥id
  static const String MY_CODE_ID = XIAOGE_SERVICE + '/shopper/codemsg';

  ///我的-我的佣金
  static const String MY_COMMISSION =
      XIAOGE_SERVICE + '/shopper/commissionlist';

  ///我的-我的客户
  static const String MY_CUSTOMER = XIAOGE_SERVICE + '/xiaoge/customerlist';

  ///我的-我的客户-修改用户
  static const String MY_CUSTOMER_EDIT =
      XIAOGE_SERVICE + '/xiaoge/customeredit';

  ///好评率排行
  static const String EVALUATE_TOP = XIAOGE_SERVICE + '/shopper/evaluatetop';

  ///客户评价
  static const String EVALUATE_COMMENT =
      XIAOGE_SERVICE + '/shopper/evaluatelist';

  ///小哥营销排名
  static const String DELIVER_ACHIEVE_RANKING =
      XIAOGE_SERVICE + '/dianzhang/xiaogedatalist';

  ///网点管理报表-网点业绩排名
  static const String DOT_STATION_DATA_LIST =
      XIAOGE_SERVICE + '/dianzhang/stationdatalist';

  ///临时展示报表页- 企业营销排名
  static const String STORE_RANKING = STORE_SERVICE + '/dashboard/index';

  ///干线--我的交接单
  static const String Driver_GetDelivery = '/driver/getDelivery';

  ///干线--干线确认包裹
  static const String Driver_Receive = STORE_SERVICE + '/driver/receive';

  ///干线--交接单详情
  static const String Driver_DeliveryDetail = '/driver/deliveryDetail';

  ///专洗-地图首页
  static const String SPECIAL_WASHING_PICKUP =
      '/specialWashing/getSepcialWashingTask';

  ///专洗-取件地图地图
  static const String PICKUP_TASK =
      '/specialWashing/gainSepcialWashingPickUpTask';

  ///专洗-送件地图地图
  static const String DELIVER_TASK =
      '/specialWashing/gainSepcialWashingDeliverTask';

  ///专洗-订单列表
  static const String ORDER_LIST =
      '/specialWashing/gainSepcialWashingOrderDetail';

  ///优洗一级子节点
  static const EXCELLENT_TYPE_NAME =
      '/api/tidy24/app/app/goodwash/GoodWash/reservation';

  ///优洗 - 分类列表子节点
  static const EXCELLENT_WASH_TYPE_CHILD =
      '/api/tidy24/app/app/goodwash/GoodWash/getGoodsChildTypeForType';

  ///优洗 - 分类列表子详情
  static const GOODS_LIST_INFO =
      '/api/tidy24/app/app/goodwash/GoodWash/goodsListForType';

  ///专洗-搜索-手机号，商品码等
  static const String SEARCH_BY_PHONE = '/specialWashing/getOrderListByPhone';

  ///专洗-洗涤订单详情
  static const String GAIN_ORDER_DETAIL = '/specialWashing/gainWashingDetail';

  ///专洗-订单留言
  static const String ORDER_MARK = '/specialWashing/orderMark';

  ///专洗-编辑地址
  static const String EDIT_ADDRESS = '/specialWashing/editAddress';

  ///专洗-添加券码
  static const String CODE_MARK = '/specialWash/addCodeMark';

  ///专洗-绑定衣物
  static const String BIND_GOODS = '/bindGoodsInfo';

  ///专洗-上传图片
  static const String UPLOAD_GOODS_IMAGES = '/uploadGoodsImages';

  ///专洗-部分签收
  static const String PARTICAL_RECEIPT = '/particalReceipt';

  ///专洗-全部签收
  static const String SING_FOR_GOODS = '/signForGoods';

  ///专洗-首页-全部订单
  static const String ALL_WASHING_LIST = '/specialWashing/gainAllWashingList';

  ///专洗-订单历史备注
  static const String ORDER_HISTORY_MARK = '/gainMarksByOrderId';

  ///专洗-修改订单支付状态
  static const String EDITING_ORDER_PAY_STATE = '/settingOrderPayState';

  ///专洗-确认订单
  static const String CONFIRM_ORDER_STATE = '/confirmOrderState';

  ///专洗-日历-预约订单
  static const String ACCEPT_ORDER = '/acceptOrder';

  ///专洗-客户签名
  static const String CONFIRM_SIGN = '/confirmSign';

  ///专洗-衣物绑码之前判断该码是否绑定过其他衣物
  static const String MATCH_CLOTHES_CODE = '/matchClothesCode';

  ///专洗-日历-始化当天基本数据
  static const String INIT_DAY_ORDER = '/initDayOrderInfo';

  ///专洗-日历-初始化当月数据
  static const String INIT_MONTH_ORDER = '/initMonthOrderInfo';

  ///专洗-单一状态下对订单进行时间排序
  static const String SORT_ORDER = '/sortOrder';
}
