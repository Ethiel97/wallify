abstract class BaseObserver<T extends Object> {
  final String name;

  BaseObserver(this.name);

  void notify(T observable);
}
