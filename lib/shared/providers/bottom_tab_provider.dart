import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bottom_tab_provider.g.dart';

@riverpod
class BottomTab extends _$BottomTab {
  @override
  int build() {
    return 0;
  }

  setTab(int index) {
    state = index;
  }
}
