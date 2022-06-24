import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mobile/main.dart';
import 'package:mobile/repositories/i_repository.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/log.dart';

class WallPaperRepository<T> extends IRepository {
  var dio = Dio();

  final CreatorCallback creatorCallback;

  final WallPaperProvider wallPaperProvider;

  final String baseApiUrl;

  WallPaperRepository({
    this.wallPaperProvider = WallPaperProvider.pexels,
    required this.creatorCallback,
    required this.baseApiUrl,
  }) {
    dio.interceptors.add(interceptorsWrapper());
  }

  InterceptorsWrapper interceptorsWrapper() {
    return InterceptorsWrapper(onRequest: (options, handler) {
      options.headers = {'Authorization': Constants.pexelsApiKey};
      options.headers = {'X-Api-Key': Constants.wallhavenApiKey};

      options.path += "&";
      String lastKey = "";
      IRepository.defaultParams.forEach((key, value) {
        lastKey = key;
      });

      IRepository.defaultParams.forEach((key, value) {
        options.path += "$key=$value${lastKey == key ? '' : '&'}";
      });

      LogUtils.log("PATH: ${options.path}");

      // options.

      // Do something before request is sent
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      LogUtils.log("uri: ${response.realUri.path.toString()}");
      Response responseModified = response
        ..data = wallPaperProvider == WallPaperProvider.pexels
            ? response.data['photos']
            : response.data['data'];

      // Do something with response data
      return handler.next(responseModified); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      LogUtils.log("dio error ${e.response?.data}");
      // Do something with response error
      return handler.resolve(e.response!); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    });
  }

  @override
  FutureOr<T> getItem(String id,
      {Map<String, dynamic> query = const {}}) async {
    String url = "${baseApiUrl}photos/$id?";

    String lastKey = "";
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    Response response = await dio.get(url);

    return creatorCallback(response.data);
  }

  @override
  FutureOr<List<T>> getItems({Map<String, dynamic> query = const {}}) async {
    String url = "${baseApiUrl}search?";

    String lastKey = "";
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    /*print(url);

    var httpresponse = await http.get(
      Uri.parse(url),
      headers: {'Authorization': Constants.pexelsApiKey!},
    );

    print(jsonDecode(httpresponse.body));*/

    Response response = await dio.get(
      url,
    );

    // LogUtils.log(response);

    return List<T>.from(
      response.data.map((x) => creatorCallback(x)),
    );
  }

  @override
  FutureOr<List<T>> searchItems({Map<String, dynamic> query = const {}}) async {
    String url = "${baseApiUrl}search?";

    String lastKey = "";
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    Response response = await dio.get(url);

    return List<T>.from(
      response.data.map((x) => creatorCallback(x)),
    );
  }
}
