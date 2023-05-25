import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:store/models/cart_item.dart';
import 'cart.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'order.dart';

class OrderList with ChangeNotifier {


  final String uid;

  final String? token;

  OrderList({required this.token,required this.uid});

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    //requisição do banco de dados
    final response = await http.post(
      //Uri + / + coleção(products) onde os dados serão armazenados //obs. terminar com '.json'
      Uri.parse('${Constants.ORDERS_BASE_URL}/$uid.json?auth=$token'),
      //objeto; convertido para json
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                },
              )
              .toList(),
        },
      ),
    );
    //criação de um Id
    final id = json.decode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrders() async {
    //limpar a lista para não acumular itens no estado local a cada possivel atualização/refresh
    //_items.clear();
    //gerar uma lista na ordem reversa
    List<Order> items = [];
    final response =
        await http.get(Uri.parse('${Constants.ORDERS_BASE_URL}/$uid.json?auth=$token'));
    if (response.body == 'null' || response.body.isEmpty) {
      // Retorna imediatamente se a resposta for nula ou o corpo estiver vazio
      //retorna um valor vazio para finalizar a operação
      return null;
    }
    //Recebe um arquivo JSON e decodifica em um map chave valor
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      //adiciona os produtos às listas vazias
      items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>)
              .where((item) => item != null)
              .map((item) {
            return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quantity: item['quantity'],
                price: item['price']);
          }).toList(),
          date: DateTime.parse(orderData['date']),
        ),
      );
    });
    _items = items.reversed.toList();//colocando a lista ao contrário
    notifyListeners();
  }
}
