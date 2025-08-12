import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(1); // Default to home screen (index 1)

  void navigateToTab(int index) {
    emit(index);
  }
}
