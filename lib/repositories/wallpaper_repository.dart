import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/wallpaper.dart';
import 'package:mobile/repositories/i_repository.dart';
import 'package:mobile/utils/constants.dart';

class WallpaperRepository extends IRrepository<Wallpaper> {
  var dio = Dio();

  WallpaperRepository() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers = {'Authorization': Constants.pexelsApiKey};
      // Do something before request is sent
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      debugPrint(e.response?.data);
      // Do something with response error
      return handler.resolve(e.response!); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));
  }

  @override
  FutureOr<Wallpaper> getItem(String id,
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

    return Wallpaper.fromJson(response.data);
  }

  @override
  FutureOr<List<Wallpaper>> getItems(
      {Map<String, dynamic> query = const {}}) async {
    String url = "${baseApiUrl}curated?";

    String lastKey = "";
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    print("URL: $url");

    /*print(url);

    var httpresponse = await http.get(
      Uri.parse(url),
      headers: {'Authorization': Constants.pexelsApiKey!},
    );

    print(jsonDecode(httpresponse.body));*/

    Response response = await dio.get(
      url,
    );

    return List<Wallpaper>.from(
      response.data['photos'].map((x) => Wallpaper.fromJson(x)),
    );
  }

  @override
  FutureOr<List<Wallpaper>> searchItems(
      {Map<String, dynamic> query = const {}}) async {
    String url = "${baseApiUrl}search?";

    String lastKey = "";
    query.forEach((key, value) {
      lastKey = key;
    });

    query.forEach((key, value) {
      url += "$key=$value${lastKey == key ? '' : '&'}";
    });

    Response response = await dio.get(url);

    return List<Wallpaper>.from(
      response.data['photos'].map((x) => Wallpaper.fromJson(x)),
    );
  }
}
