import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(Product product) {
    //verificação se o item adicionado no carrinho já se encontra inserido(verifica pelo product.id).
    //caso o item já tenha sido inserido no carrinho
    if (_items.containsKey(product.id)) {
      //chave -> product.id
      _items.update(
        product.id,
        (existingItem) => CartItem(
          //id é especifico do item do carrinho
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
      //caso o item não esteja no carrinho
    } else {
      //insira se não tiver presente
      _items.putIfAbsent(
        //chave -> product.id
        product.id,
        () => CartItem(
          //id é especifico do item do carrinho
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  //quantidade total de tipos de itens no carrinho
  int get itemsTypeCount {
    return items.length;
  }


  //itemsCount que descreve quantos items existem no geral
    int get itemsCount {
    int total = 0;
    _items.forEach((key, cartItem) {total += cartItem.quantity;});
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    //para cara item no Map _items ele irá pegar o item do map(cartItem) e realizará uma adição a variável 'total'.
    _items.forEach((key, cartItem) => total += cartItem.price * cartItem.quantity );
    return total;
  }

  //remover itens da lista
  void removeItem(String productId) {
    _items.remove(productId);
    //notificar de mudanças no estado
    notifyListeners();
  }

  //limpar a lista
  void clear() {
    _items = {};
    notifyListeners();
  }
}
