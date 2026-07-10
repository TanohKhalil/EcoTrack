import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<ProduitMarketplace>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<ProduitMarketplace>> {
  CartNotifier() : super([]);

  void add(ProduitMarketplace product) {
    state = [...state, product];
  }

  void remove(int index) {
    state = [...state..removeAt(index)];
  }

  void clear() {
    state = [];
  }

  int get total {
    return state.fold(0, (sum, item) => sum + item.prixFCFA);
  }
}
