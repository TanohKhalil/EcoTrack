import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final langProvider = StateNotifierProvider<LangNotifier, String>((ref) {
  return LangNotifier();
});

class LangNotifier extends StateNotifier<String> {
  LangNotifier() : super('fr') {
    _loadLang();
  }

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('locale') ?? 'fr';
    state = stored;
  }

  Future<void> setLang(String locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }
}
