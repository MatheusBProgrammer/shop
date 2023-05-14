import 'package:flutter/foundation.dart';
//mixin com ChangeNotifier para notificar qualquer mudança na classe (isFavorite)
class Product with ChangeNotifier{
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    //notifica de forma reativa a mudança do estado de isFavorite
    notifyListeners();
  }
}
