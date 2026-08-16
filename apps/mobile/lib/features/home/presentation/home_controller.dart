import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  int build() {
    return 0; // 0: Map, 1: Feed
  }

  void setTab(int index) {
    state = index;
  }
}
