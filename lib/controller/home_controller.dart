import 'package:book_store_admin/model/app_page.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var appPage = AppPage.category().obs;
  var drawerOpen = true.obs;

  void changeAppPage(AppPage v) => appPage.value = v;
  void changeDrawerOpen() => drawerOpen.value = !drawerOpen.value;
}
