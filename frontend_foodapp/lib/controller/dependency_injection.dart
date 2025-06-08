import 'package:frontend_foodapp/controller/network_controller.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    // Initialize all dependencies here
    // For example:
    // Get.lazyPut<SomeService>(() => SomeService());
    // Get.lazyPut<AnotherController>(() => AnotherController());
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
