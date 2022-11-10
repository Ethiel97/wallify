import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:provider/provider.dart';


class NavigationProvider with ChangeNotifier {
  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    if (index != 2) {
      _currentIndex = index;
      notifyListeners();
    } else if (index == 2 &&
        Provider.of<AuthProvider>(Get.context!, listen: false).status ==
            Status.authenticated) {
      _currentIndex = index;
      notifyListeners();
    } else {
      Get.toNamed(RouteName.login);
    }
  }
}
