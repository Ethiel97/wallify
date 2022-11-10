import 'dart:async';

import 'package:mobile/utils/constants.dart';

abstract class IRepository<T> {
  static const Map defaultParams = {
    'per_page': Constants.perPageResults,
    'purity': 100,
    'sorting': 'relevance',
    'order': 'desc'
  };

  FutureOr<List<T>> getItems({Map<String, dynamic> query = const {}});

  FutureOr<List<T>> searchItems({Map<String, dynamic> query = const {}});

  FutureOr<T> getItem(int id, {Map<String, dynamic> query = const {}});
}
