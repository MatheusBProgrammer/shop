import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/data/dummy_data.dart';
import 'package:store/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  //retorna uma cótia de _items, para impedir modificações diretas pelo usuário
  List<Product> get items => [..._items];

  //gera uma lista de favoritos caso o valor boleano de favoritos seja true
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);

    //notifica de forma reativa a adição de um product à lista _items
    notifyListeners();
  }
}

//seleção de favoritos de maneira global
/*
class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  //retorna uma cótia de _items, para impedir modificações diretas pelo usuário
  List<Product> get items => _showFavoriteOnly ? _items.where((product)=> product.isFavorite).toList() : [..._items];

  void showFavoriteOnly(){
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll(){
    _showFavoriteOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(product);

    //notifica de forma reativa a adição de um product à lista _items
    notifyListeners();
  }
}

*/
