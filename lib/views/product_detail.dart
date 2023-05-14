import 'package:flutter/material.dart';

import '../models/product.dart';

//chamado em product_item.dart
class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //recebimento de argumento por pushNamed para um Widget que não recebe via construtor
    final Product product = ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text(product.name),
      backgroundColor: Theme.of(context).primaryColor,),
    );
  }
}
