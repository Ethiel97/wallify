import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';
import 'package:mobile/utils/secure_storage.dart';
import 'package:provider/provider.dart';

class ApiProvider {
  static var dio = Dio();

  InterceptorsWrapper interceptorsWrapper() =>
      InterceptorsWrapper(onRequest: (options, handler) async {
        try {
          options.headers = {
            'content-type': 'application/json',
          };

          /*if (await SecureStorageService.readItem(key: authTokenKey) != null) {
            options.headers['Authorization'] =
                'Bearer ${(await SecureStorageService.readItem(key: authTokenKey))}';
          }*/

          if (Provider.of<AuthProvider>(Get.Get.context!, listen: false)
                  .status ==
              Status.authenticated) {
            options.headers['Authorization'] =
                'Bearer ${(await SecureStorageService.readItem(key: authTokenKey))}';
          }
        } catch (e) {
          print(e);
        }

        // options.

        // Do something before request is sent
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        // LogUtils.log("uri: ${response.realUri.path.toString()}");

        // LogUtils.log(response.data);
        return handler.resolve(response);
      }, onError: (DioError e, handler) {
        LogUtils.log("dio error ${e.response?.data}");
        // Do something with response error
        return handler.resolve(e.response!); //continue
      });

  ApiProvider() {
    dio.interceptors.add(interceptorsWrapper());
  }

  Future<Map<String, dynamic>> login(Map data) async {
    Response response =
        await dio.post("${Constants.customApiUrl!}auth/local", data: {
      ...data,
    });

    return response.data;
  }

  Future<Map<String, dynamic>> register(Map data) async {
    Response response =
        await dio.post("${Constants.customApiUrl!}auth/local/register", data: {
      ...data,
    });

    // print("response: $")

    return response.data;
  }

  Future<Map<String, dynamic>> fetchMe() async {
    Response response = await dio.get("${Constants.customApiUrl!}users/me");

    return response.data;
  }

  Future<List> fetchSavedWallpapers() async {
    Response response =
        await dio.get("${Constants.customApiUrl!}saved-wallpapers");

    // LogUtils.log("SAVED WALLPAPERS: ${response.data['data']}");

    return response.data['data'];
  }

  saveWallPaper(String wallpaperId) async {
    Response response =
        await dio.post("${Constants.customApiUrl!}saved-wallpapers", data: {
      "data": {"uid": wallpaperId}
    });
  }

  deleteSavedWallPaper(String wallpaperId) async {
    Response response = await dio.delete(
      "${Constants.customApiUrl!}saved-wallpapers/remove/$wallpaperId",
    );
  }
}
