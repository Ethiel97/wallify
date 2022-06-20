import 'dart:async';

import 'package:mobile/utils/constants.dart';

abstract class IRepository<T> {
  // final String baseApiUrl = Constants.pexelsApiHost!;
  final String baseApiUrl = Constants.wallhavenApiHost!;

 static const Map defaultParams = {'per_page': Constants.perPageResults};

  FutureOr<List<T>> getItems({Map<String, dynamic> query =  const {}});

  FutureOr<List<T>> searchItems({Map<String, dynamic> query = const {}});

  FutureOr<T> getItem(String id, {Map<String, dynamic> query = const {}});
}
