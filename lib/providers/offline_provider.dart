import 'package:flutter_riverpod/flutter_riverpod.dart';

final offlineProvider = StateNotifierProvider<OfflineNotifier, bool>((ref) {
  return OfflineNotifier();
});

class OfflineNotifier extends StateNotifier<bool> {
  OfflineNotifier() : super(false);

  void toggle() {
    state = !state;
  }

  void setOffline(bool value) {
    state = value;
  }
}
