import 'dart:async';

import 'package:flutter/material.dart';

abstract class BaseViewModel<T extends Object> with ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  bool _isInitializeDone = false;
  bool _hasError = false;
  bool _canRefresh = false;

  Timer? _debounceTimer;

  String errorMessage = "";

  final String? defaultLocale =
      WidgetsBinding.instance.window.locale.languageCode;

  FutureOr<void> _initState;

  int get size => 0;

  int get favSize => 0;

  BaseViewModel() {
    _init();
  }

  FutureOr<void> init();

  void loadMore();

  void _init() async {
    isLoading = true;
    _initState = init();
    await _initState;
    _isInitializeDone = true;
    isLoading = false;
  }

  void changeStatus() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void reloadState() {
    if (!isLoading) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  //Getters
  FutureOr<void> get initState => _initState;

  bool get isLoading => _isLoading;

  bool get isDisposed => _isDisposed;

  bool get isInitialized => _isInitializeDone;

  bool get hasError => _hasError;

  bool get canRefresh => _canRefresh;

  set error(bool error) {
    _hasError = error;
    reloadState();
  }

  set canRefresh(bool val) {
    _canRefresh = val;
    reloadState();
  }

  //Setters
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }

  finishLoading() {
    _isLoading = false;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }

  void debouncing({required Function() fn, int waitForMs = 500}) {
    // if this function is called before 500ms [waitForMs] expired
    //cancel the previous call

    _debounceTimer?.cancel();

    /// set a 500ms [waitForMs] timer for the [fn] to be called
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }
}
