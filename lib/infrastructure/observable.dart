import 'package:flutter/foundation.dart';

import 'observer.dart';

class Observable<T extends Object> with ChangeNotifier {
  late T observable;

  List<BaseObserver<T>> observers = [];

  void subscribe(BaseObserver<T> observer) {
    observers.add(observer);
    if (hasListeners) notifyListeners();
  }

  void transform(T obs, [Object? data]) {
    observable = obs;
    notifySubscribers();
  }

  void unSubscribe(BaseObserver<T> observer) {
    observers.removeWhere((element) => element == observer);
    if (hasListeners) notifyListeners();
  }

  void notifySubscribers() {
    for (var subscriber in observers) {
      subscriber.notify(observable);
      // notifyListeners();
    }
  }
}
