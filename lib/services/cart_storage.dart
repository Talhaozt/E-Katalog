import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static const String key = 'cart_ids';

  // Sepetteki ürün ID'lerini kaydeder
  static Future<void> saveCart(Set<int> cartIds) async {
    final prefs = await SharedPreferences.getInstance();
    final list = cartIds.map((id) => id.toString()).toList();
    await prefs.setStringList(key, list);
  }

  // Kaydedilmiş ürün ID'lerini yükler
  static Future<Set<int>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.map((id) => int.tryParse(id) ?? 0).toSet();
  }

  // Sepeti temizler
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}