import 'package:hive_flutter/adapters.dart';

class HiveService {
  static var box = Hive.box('settings');

   void setLoginStatus(bool isLogin) {
    box.put("isLogin", isLogin);
  }

   get isLoggedIn {
    return box.get("isLogin", defaultValue: false);
  }
}
