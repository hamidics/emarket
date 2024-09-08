/*
  
 */

import 'package:eMarket/core/common/navigation_service.dart';
import 'package:eMarket/core/common/notification_service.dart';
import 'package:eMarket/core/services/category_service.dart';
import 'package:eMarket/core/services/controllers/category_service_controller.dart';
import 'package:eMarket/core/services/controllers/customer_service_controller.dart';
import 'package:eMarket/core/services/controllers/global_service_controller.dart';
import 'package:eMarket/core/services/controllers/order_service_controller.dart';
import 'package:eMarket/core/services/controllers/product_service_controller.dart';
import 'package:eMarket/core/services/controllers/user_service_controller.dart';
import 'package:eMarket/core/services/customer_service.dart';
import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/core/services/order_service.dart';
import 'package:eMarket/core/services/product_service.dart';
import 'package:eMarket/core/services/user_service.dart';
import 'package:eMarket/ui/pages/category/home/category_home_viewmodel.dart';
import 'package:eMarket/ui/pages/customer/main/customer_main_viewmodel.dart';
import 'package:eMarket/ui/pages/product/home/product_home_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupServices() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NotificationService());

  //> Services
  locator.registerLazySingleton<GlobalService>(() => GlobalServiceController());

  locator.registerLazySingleton<UserService>(() => UserServiceController());

  locator
      .registerLazySingleton<ProductService>(() => ProductServiceController());

  locator.registerLazySingleton<CustomerService>(
      () => CustomerServiceController());

  locator.registerLazySingleton<OrderService>(() => OrderServiceController());

  locator.registerLazySingleton<CategoryService>(
      () => CategoryServiceController());

  // ViewModels
  locator.registerLazySingleton(() => ProductHomeViewModel());
  locator.registerLazySingleton(() => CategoriesHomeViewModel());
  locator.registerLazySingleton(() => CustomerMainViewModel());
}
