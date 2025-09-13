import 'package:flutter_bloc/flutter_bloc.dart';

class NavItem {
  static const home = 0;
  static const explore = 1;
  static const live = 2;
  static const myList = 3;
  static const profile = 4;
}

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(NavItem.home);
  void select(int index) => emit(index);
}
