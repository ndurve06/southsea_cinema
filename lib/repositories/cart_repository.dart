import 'package:southsea_cinema/models/cart_item.dart';

class CartRepository {
  CartRepository._internal();

  static final CartRepository instance = CartRepository._internal();

  final List<CartItem> _items = [];

  List<CartItem> getItems() {
    return List<CartItem>.unmodifiable(_items);
  }

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int getTotalItems() {
    int total = 0;
    for (final CartItem item in _items) {
      total += item.quantity;
    }
    return total;
  }

  double getTotal() {
    double sum = 0.0;
    for (final CartItem item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  void clear() {
    _items.clear();
  }
}
