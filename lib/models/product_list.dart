import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store/data/dummy_data.dart';
import 'package:store/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-matheus-d416a-default-rtdb.firebaseio.com';
  List<Product> _items = dummyProducts;

  //retorna uma cótia de _items, para impedir modificações diretas pelo usuário
  List<Product> get items => [..._items];

  //gera uma lista de favoritos caso o valor boleano de favoritos seja true
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    //Post -> adiciona dados
    final future = http.post(
        //Uri + / + coleção(products) onde os dados serão armazenados //obs. terminar com '.json'
        Uri.parse('$_baseUrl/products.json'),
        //objeto; convertido para json
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));
    //executa depois de receber a requisição do Banco de Dados
    future.then((response) {
      //gerando um id a partir do banco de dados
      final id = json.decode(response.body)['name'];
      //adicionando o item ao provider
      _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ));
      //notifica de forma reativa a adição de um product à lista _items
      notifyListeners();
    });
  }

  //Usado pelo Gerenciador de produtos, recebendo um Map(data) e no final usando o addProduct para adicionar o item à lista de Product's
  void saveProductFromData(Map<String, Object> data) {
    //caso já tenha um Id definido, a variável booleana retorna true
    bool hasId = data['id'] != null;

    final product = Product(
      //Verificação: Possui id? usa o id ja definido, caso não possua, gera um número aleatório como id
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      //atualiza o produto
      updateProduct(product);
    } else {
      //adiciona o produto
      addProduct(product);
    }
  }

  void updateProduct(Product product) {
    //Verificar se o índice é menor do que 0, significa que é inválido, caso contrário, é valido.
    int index = _items.indexWhere((p) => p.id == product.id);

    //verifica se o produto tem índice válido
    if (index >= 0) {
      //substituir o item atual pelo produto
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    //verifica se o produto tem índice válido
    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  int get itemsCount {
    return items.length;
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
