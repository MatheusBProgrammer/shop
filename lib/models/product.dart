import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

//mixin com ChangeNotifier para notificar qualquer mudança na classe (isFavorite)
class Product with ChangeNotifier {
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

  void _toggleFavorite() async {
    isFavorite = !isFavorite;
    //notifica de forma reativa a mudança do estado de isFavorite
    notifyListeners();
  }
  Future<void> toggleFavorite(String token, String uid) async {
    try{
      _toggleFavorite();
      notifyListeners();
      //path -> atualiza
      //put -> sobrescreve
      final response = await http.put(
        //é necessário interpolar com o Id para alterar o produto específico
        Uri.parse('${Constants.USER_FAVORITES}/$uid/$id.json?auth=$token'),
        //objeto; convertido para json
        body: jsonEncode(
            isFavorite,
        ),
      );
      //caso ocorra um erro, ele retorna valor ao original
      if(response.statusCode >= 400){
        _toggleFavorite();
        //notifica de forma reativa a mudança do estado de isFavorite
        notifyListeners();
      }

    }
    catch(e){
    _toggleFavorite();
    notifyListeners();
    }
  }
}
