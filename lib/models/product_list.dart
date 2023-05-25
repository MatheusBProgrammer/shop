import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store/models/product.dart';
import '../exceptions/http_exception.dart';
import '../utils/constants.dart';

class ProductList with ChangeNotifier {
  final String uid;

  final String token;

  ProductList(
    this.uid, {
    required this.token,
  });

  List<Product> _items = [];

  //Url do banco de dados
  final _baseUrl = Constants.PRODUCT_BASE_URL;

  //lista que será configurada sempre que o loadProducts for chamado ( initState do products_overview_page)

  //retorna uma cótia de _items, para impedir modificações diretas pelo usuário
  List<Product> get items => [..._items];

  //gera uma lista de favoritos caso o valor boleano de favoritos seja true
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

//carrega os produtos do Banco de dados em uma requisição futura que usa o await para esperar os dados chegarem
  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse('${_baseUrl}.json?auth=$token'));

    if (response.body == 'null' || response.body.isEmpty) {
      // Retorna imediatamente se a resposta for nula ou o corpo estiver vazio
      //retorna um valor vazio para finalizar a operação
      return;
    }

    //Favoritos, que estão em uma tabela separada no banco de dados, devemos relacionar cada produto com o favorito(por usuário)
    final favResponse = await http.get(
      //é necessário interpolar com o Id para alterar o produto específico
      Uri.parse('${Constants.USER_FAVORITES}/$uid.json?auth=$token'),
      //objeto; convertido para json
    );

    //O Map é o /id dentro da requisição uid/
    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    //Recebe um arquivo JSON e decodifica em um map chave valor
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, dataValue) {
      final isFavorite = favData[key] ?? false;
      //adiciona os produtos às listas vazias
      _items.add(Product(
        //é colocada uma verificação para garantir de que campos vazios não irão gerar erros
        id: key,
        name: dataValue['name'] ?? '',
        description: dataValue['description'] ?? '',
        price: dataValue['price'] ?? 0.0,
        imageUrl: dataValue['imageUrl'] ?? '',
        isFavorite: isFavorite
      ));
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    //Requisição ao banco de dados
    //Post -> adiciona dados
    //a variável 'response' está sendo criada apenas no intuito de futuramente gerar um ID para o _items, pois localiza o id do banco de dados
    //a partir do response.body['name']
    final response = await http.post(
      //Uri + / + coleção(products) onde os dados serão armazenados
      //obs. terminar com '.json'
      Uri.parse('$_baseUrl.json?auth=$token'),
      //objeto; convertido para json
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );
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
  }
  Future<void> updateProduct(Product product) async {
    //Localizar o index e verificar se o índice é menor do que 0, significa que é inválido, caso contrário, é valido.
    int index = _items.indexWhere((p) => p.id == product.id);

    //verifica se o produto tem índice válido
    if (index >= 0) {
      await http.patch(
        //é necessário interpolar com o Id para alterar o produto específico
        Uri.parse('$_baseUrl/${product.id}.json?auth=$token'),
        //objeto; convertido para json
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );
      //substituir o item atual pelo produto
      _items[index] = Product(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      notifyListeners();
    }
  }
  //Usado pelo Gerenciador de produtos, recebendo um Map(data) e no final usando o addProduct para adicionar o item à lista de Product's
  Future<void> saveProductFromData(Map<String, Object> data) async {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      //Fará um path no banco de dados
      return updateProduct(product);
    } else {
      //dará um post no banco de dados
      return addProduct(product);
    }
  }



  //remover o produto, Exclusão otimista(Remove primeiro na interface gráfica e depois no banco de dados)
  Future<void> removeProduct(Product product) async {
    //Gera um index
    int index = _items.indexWhere((p) => p.id == product.id);
    //Verifica se o produto tem índice válido
    if (index >= 0) {
      final product = _items[index];

      //Para uma EXCLUSÃO OTIMISTA, primeiro removemos o produto na interface grafica, que se relaciona diretamente
      //com _items, para depois fazer a exclusão no banco de dados;
      //Caso a exclusão no banco de dados não seja efetuada com sucesso,
      //colocaremos o item de volta a _items por meio de um _items.insert
      _items.remove(product);
      notifyListeners();

      //após verificar se faz parte da lista, ele deleta no Firebase
      final response = await http.delete(
        //é necessário interpolar com o Id para alterar o produto específico
        Uri.parse('$_baseUrl/${product.id}json?auth=$token'),
        //objeto; convertido para json
      );

//### TRATAMENTO DE ERRO ###
//>= 400 como padrão como ERRO de requisição
      if (response.statusCode >= 400) {
        //restaura o item e notifica o usuário
        _items.insert(index, product);
        notifyListeners();

        //lançamento de exceção:
        throw HttpException(
            msg: 'Não foi possível excluir o produto',
            statusCode: response.statusCode);
      }
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
