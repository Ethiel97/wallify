import 'dart:async';

import 'package:mobile/utils/constants.dart';

abstract class IRrepository<T extends Object> {
  final String baseApiUrl = Constants.pexelsApiHost!;

  FutureOr<List<T>> getItems({Map<String, dynamic> query = const {}});

  FutureOr<List<T>> searchItems({Map<String, dynamic> query = const {}});

  FutureOr<T> getItem(String id, {Map<String, dynamic> query = const {}});
}
