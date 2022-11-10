import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/secure_storage.dart';
import 'package:mobile/widgets/utilities.dart';
import 'package:tinycolor2/tinycolor2.dart';

import 'api_provider.dart';

const String authTokenKey = 'token';
const String userKey = 'user';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  operating,
  finished
}

enum AppStatus {
  processing,
  finished,
  initialized,
}

class AuthProvider with ChangeNotifier {
  static String token = "";

  // APIProvider _apiProvider = Provider.of(context);
  Status _status = Status.unauthenticated;
  AppStatus _appStatus = AppStatus.initialized;

  // APIProvider _apiProvider = Provider.of(context);
  Status get status => _status;

  AppStatus get appStatus => _appStatus;

  User? authUser;

  String get jwtToken => token;

  set status(val) {
    _status = val;

    notifyListeners();
  }

  AuthProvider() {
    try {
      /*fetchMe().then((res) {

        LogUtils.log("fetch me response: ${res}");
        if ((res as Map).containsKey('error') &&
            res['error']['status'] == 403) {
          LogUtils.log("unauthenticated");
          _status = Status.unauthenticated;
          SecureStorageService.remove(key: authTokenKey);
        } else {*/
      checkAuthStatus().then((authToken) {
        if (authToken != null) {
          token = authToken;
          _status = token.trim().isEmpty
              ? Status.unauthenticated
              : Status.authenticated;

          if (_status == Status.authenticated) {
            fetchLocalUser();
          } else {
            // Get.toNamed(routes.login);
          }
        } else {
          // Get.toNamed(routes.login);
        }
      });
      /*  }
      });*/
    } catch (e, stack) {
      LogUtils.log("Error: $e, Stack:$stack");
    }
  }

  set user(User user) {
    authUser = user;
    SecureStorageService.saveItem(
        key: userKey, data: jsonEncode(user.toJson()));
    notifyListeners();
  }

  /*Future<void> fetchAndUpdateUser() async {
    try {
      this.user = (await APIProvider.fetchLoggedInUser(authUser.id)).entity;
    } catch (e) {
      print(e);
      var data = (await APIProvider.fetchLoggedInUser(authUser.id)).data;

      user = User.fromJson(data);
    }
  }*/

  fetchMe() async {
    var response = await ApiProvider().fetchMe();
    return response;
  }

  fetchLocalUser() async {
    String? data = await SecureStorageService.readItem(key: userKey);

    user = User.fromJson(jsonDecode(data!));

    debugPrint("USER: ${User.fromJson(jsonDecode(data))}");
  }

  setAppStatus(val) {
    _appStatus = val;
    notifyListeners();
  }

  Future<String?> checkAuthStatus() async {
    var token = await SecureStorageService.readItem(key: authTokenKey);
    return token;
  }

/*
  Future<String> update(Map data) async {
    try {
      _appStatus = AppStatus.Processing;
      notifyListeners();

      BasicServerResponse serverResponse =
      await APIProvider.editAccount(authUser.id, data);

      if (serverResponse.status == 200 || serverResponse.status == 201) {
        // await this.fetchAndUpdateUser();

        try {
          this.user = serverResponse.entity;
        } catch (e) {
          print(e);
          this.user = User.fromJson(serverResponse.data);
        }
      }
      _appStatus = AppStatus.Finished;
      notifyListeners();

      return serverResponse.message;
    } catch (e) {
      print(e);
      _appStatus = AppStatus.Finished;
      notifyListeners();

      return 'Oops! Une erreur est survenue';
    }
  }
*/

  Future<void> login(Map data) async {
    var message = "";
    try {
      status = Status.authenticating;

      _appStatus = AppStatus.processing;
      notifyListeners();

      Map<String, dynamic> response = await ApiProvider().login(data);
      if (response.containsKey('jwt')) {
        LogUtils.log("USER: ${response['user']}");

        user = User.fromJson(response['user']);

        SecureStorageService.saveItem(key: authTokenKey, data: response['jwt']);
        status = Status.authenticated;
        notifyListeners();

        message = AppLocalizations.of(Get.context!)!.successful_operation;

        _appStatus = AppStatus.finished;
        notifyListeners();

        Get.offAllNamed(RouteName.landing);
      } else {
        status = Status.unauthenticated;
        notifyListeners();

        _appStatus = AppStatus.finished;
        notifyListeners();

        message = AppLocalizations.of(Get.context!)!.check_credentials;
      }

      notifyListeners();
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      _appStatus = AppStatus.finished;
      notifyListeners();
      _status = Status.unauthenticated;
      notifyListeners();
      message = AppLocalizations.of(Get.context!)!.error_occured;
    } finally {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        message,
        duration: const Duration(seconds: 7),
        backgroundColor: status == Status.authenticated
            ? TinyColor(AppColors.accentColor).darken().color
            : AppColors.darkColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> register(Map data) async {
    var message = "";

    try {
      status = Status.authenticating;
      notifyListeners();

      _appStatus = AppStatus.processing;
      notifyListeners();

      Map<String, dynamic> response = await ApiProvider().register(data);
      if (response.containsKey('jwt')) {
        user = User.fromJson(response['user']);

        SecureStorageService.saveItem(key: authTokenKey, data: response['jwt']);
        status = Status.authenticated;
        notifyListeners();

        message = AppLocalizations.of(Get.context!)!.successful_operation;

        _appStatus = AppStatus.finished;
        notifyListeners();
        Get.offAllNamed(RouteName.landing);
      } else {
        status = Status.unauthenticated;
        notifyListeners();

        _appStatus = AppStatus.finished;
        notifyListeners();
        message = AppLocalizations.of(Get.context!)!.email_or_username_taken;
      }
    } catch (e) {
      debugPrint(e.toString());
      _appStatus = AppStatus.finished;
      notifyListeners();
      message = AppLocalizations.of(Get.context!)!.error_occured;
    } finally {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        message,
        duration: const Duration(seconds: 7),
        backgroundColor: status == Status.authenticated
            ? TinyColor(AppColors.accentColor).darken().color
            : AppColors.darkColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteAccount() async {
    String message = "";

    try {
      _appStatus = AppStatus.processing;
      notifyListeners();

      await ApiProvider().deleteUserSavedWallPapers();
      await ApiProvider().deleteAccount(authUser!.id!);

      message = AppLocalizations.of(Get.context!)!.account_delete_success;

      _appStatus = AppStatus.finished;
      notifyListeners();

      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        message,
        duration: const Duration(seconds: 7),
        backgroundColor: status == Status.authenticated
            ? TinyColor(AppColors.accentColor).darken().color
            : AppColors.darkColor,
        colorText: Colors.white,
      );

      logout();
    } catch (e) {
      debugPrint(e.toString());
      _appStatus = AppStatus.finished;
      message = AppLocalizations.of(Get.context!)!.error_occured;
      notifyListeners();

      Get.snackbar(
        AppLocalizations.of(Get.context!)!.notification,
        message,
        duration: const Duration(seconds: 5),
        backgroundColor: AppColors.darkColor,
        colorText: Colors.white,
      );
    }
  }

  confirmLogout() {
    utilities.confirmActionSnack(
      message: AppLocalizations.of(Get.context!)!.logout_confirmation,
      action: () => logout(),
      actionText: AppLocalizations.of(Get.context!)!.logout,
    );
  }

  confirmAccountDeletion() {
    utilities.confirmActionSnack(
      message: AppLocalizations.of(Get.context!)!.account_delete_confirmation,
      action: () => deleteAccount(),
      actionText: AppLocalizations.of(Get.context!)!.delete,
    );
  }

  Future<void> logout() async {
    user = User();
    notifyListeners();
    _status = Status.unauthenticated;
    notifyListeners();
    await SecureStorageService.remove(key: authTokenKey);
    await SecureStorageService.remove(key: userKey);
    await Future.delayed(const Duration(milliseconds: 400));
    Get.offAllNamed(RouteName.splash);
  }
}
